from __future__ import annotations

import datetime
import itertools
import os
import re
import struct
import sys
import uuid
from codecs import utf_8_decode as _utf_8_decode
from codecs import utf_8_encode as _utf_8_encode
from collections import abc as _abc
from typing import (
    IO,
    TYPE_CHECKING,
    Any,
    BinaryIO,
    Callable,
    Generator,
    Iterator,
    Mapping,
    MutableMapping,
    NoReturn,
    Optional,
    Sequence,
    Tuple,
    Type,
    TypeVar,
    Union,
    cast,
    overload,
)


def get_data_and_view(data: Any) -> Tuple[Any, memoryview]:
    if isinstance(data, (bytes, bytearray)):
        return data, memoryview(data)
    view = memoryview(data)
    return view.tobytes(), view


def _raise_unknown_type(element_type: int, element_name: str) -> NoReturn:
    """Unknown type helper."""
    raise InvalidBSON(
        "Detected unknown BSON type {!r} for fieldname '{}'. Are "
        "you using the latest driver version?".format(chr(element_type).encode(), element_name)
    )


def _get_int(
    data: Any, _view: Any, position: int, dummy0: Any, dummy1: Any, dummy2: Any
) -> Tuple[int, int]:
    """Decode a BSON int32 to python int."""
    return _UNPACK_INT_FROM(data, position)[0], position + 4


def _get_c_string(data: Any, view: Any, position: int, opts: CodecOptions[Any]) -> Tuple[str, int]:
    """Decode a BSON 'C' string to python str."""
    end = data.index(b"\x00", position)
    return _utf_8_decode(view[position:end], opts.unicode_decode_error_handler, True)[0], end + 1


def _get_float(
    data: Any, _view: Any, position: int, dummy0: Any, dummy1: Any, dummy2: Any
) -> Tuple[float, int]:
    """Decode a BSON double to python float."""
    return _UNPACK_FLOAT_FROM(data, position)[0], position + 8


def _get_string(
    data: Any, view: Any, position: int, obj_end: int, opts: CodecOptions[Any], dummy: Any
) -> Tuple[str, int]:
    """Decode a BSON string to python str."""
    length = _UNPACK_INT_FROM(data, position)[0]
    position += 4
    if length < 1 or obj_end - position < length:
        raise InvalidBSON("invalid string length")
    end = position + length - 1
    if data[end] != 0:
        raise InvalidBSON("invalid end of string")
    return _utf_8_decode(view[position:end], opts.unicode_decode_error_handler, True)[0], end + 1


def _get_object_size(data: Any, position: int, obj_end: int) -> Tuple[int, int]:
    """Validate and return a BSON document's size."""
    try:
        obj_size = _UNPACK_INT_FROM(data, position)[0]
    except struct.error as exc:
        raise InvalidBSON(str(exc)) from None
    end = position + obj_size - 1
    if data[end] != 0:
        raise InvalidBSON("bad eoo")
    if end >= obj_end:
        raise InvalidBSON("invalid object length")
    # If this is the top-level document, validate the total size too.
    if position == 0 and obj_size != obj_end:
        raise InvalidBSON("invalid object length")
    return obj_size, end


def _get_object(
    data: Any, view: Any, position: int, obj_end: int, opts: CodecOptions[Any], dummy: Any
) -> Tuple[Any, int]:
    """Decode a BSON subdocument to opts.document_class or bson.dbref.DBRef."""
    obj_size, end = _get_object_size(data, position, obj_end)
    if _raw_document_class(opts.document_class):
        return (opts.document_class(data[position : end + 1], opts), position + obj_size)

    obj = _elements_to_dict(data, view, position + 4, end, opts)

    position += obj_size
    # If DBRef validation fails, return a normal doc.
    if (
        isinstance(obj.get("$ref"), str)
        and "$id" in obj
        and isinstance(obj.get("$db"), (str, type(None)))
    ):
        return (DBRef(obj.pop("$ref"), obj.pop("$id", None), obj.pop("$db", None), obj), position)
    return obj, position


def _get_array(
    data: Any, view: Any, position: int, obj_end: int, opts: CodecOptions[Any], element_name: str
) -> Tuple[Any, int]:
    """Decode a BSON array to python list."""
    size = _UNPACK_INT_FROM(data, position)[0]
    end = position + size - 1
    if data[end] != 0:
        raise InvalidBSON("bad eoo")

    position += 4
    end -= 1
    result: list[Any] = []

    # Avoid doing global and attribute lookups in the loop.
    append = result.append
    index = data.index
    getter = _ELEMENT_GETTER
    decoder_map = opts.type_registry._decoder_map

    while position < end:
        element_type = data[position]
        # Just skip the keys.
        position = index(b"\x00", position) + 1
        try:
            value, position = getter[element_type](
                data, view, position, obj_end, opts, element_name
            )
        except KeyError:
            _raise_unknown_type(element_type, element_name)

        if decoder_map:
            custom_decoder = decoder_map.get(type(value))
            if custom_decoder is not None:
                value = custom_decoder(value)

        append(value)

    if position != end + 1:
        raise InvalidBSON("bad array length")
    return result, position + 1


def _get_binary(
    data: Any, _view: Any, position: int, obj_end: int, opts: CodecOptions[Any], dummy1: Any
) -> Tuple[Union[Binary, uuid.UUID], int]:
    """Decode a BSON binary to bson.binary.Binary or python UUID."""
    length, subtype = _UNPACK_LENGTH_SUBTYPE_FROM(data, position)
    position += 5
    if subtype == 2:
        length2 = _UNPACK_INT_FROM(data, position)[0]
        position += 4
        if length2 != length - 4:
            raise InvalidBSON("invalid binary (st 2) - lengths don't match!")
        length = length2
    end = position + length
    if length < 0 or end > obj_end:
        raise InvalidBSON("bad binary object length")

    # Convert UUID subtypes to native UUIDs.
    if subtype in ALL_UUID_SUBTYPES:
        uuid_rep = opts.uuid_representation
        binary_value = Binary(data[position:end], subtype)
        if (
            (uuid_rep == UuidRepresentation.UNSPECIFIED)
            or (subtype == UUID_SUBTYPE and uuid_rep != STANDARD)
            or (subtype == OLD_UUID_SUBTYPE and uuid_rep == STANDARD)
        ):
            return binary_value, end
        return binary_value.as_uuid(uuid_rep), end

    # Decode subtype 0 to 'bytes'.
    if subtype == 0:
        value = data[position:end]
    else:
        value = Binary(data[position:end], subtype)

    return value, end


def _get_oid(
    data: Any, _view: Any, position: int, dummy0: Any, dummy1: Any, dummy2: Any
) -> Tuple[ObjectId, int]:
    """Decode a BSON ObjectId to bson.objectid.ObjectId."""
    end = position + 12
    return ObjectId(data[position:end]), end


def _get_boolean(
    data: Any, _view: Any, position: int, dummy0: Any, dummy1: Any, dummy2: Any
) -> Tuple[bool, int]:
    """Decode a BSON true/false to python True/False."""
    end = position + 1
    boolean_byte = data[position:end]
    if boolean_byte == b"\x00":
        return False, end
    elif boolean_byte == b"\x01":
        return True, end
    raise InvalidBSON("invalid boolean value: %r" % boolean_byte)


def _get_date(
    data: Any, _view: Any, position: int, dummy0: int, opts: CodecOptions[Any], dummy1: Any
) -> Tuple[Union[datetime.datetime, DatetimeMS], int]:
    """Decode a BSON datetime to python datetime.datetime."""
    return _millis_to_datetime(_UNPACK_LONG_FROM(data, position)[0], opts), position + 8


def _get_code(
    data: Any, view: Any, position: int, obj_end: int, opts: CodecOptions[Any], element_name: str
) -> Tuple[Code, int]:
    """Decode a BSON code to bson.code.Code."""
    code, position = _get_string(data, view, position, obj_end, opts, element_name)
    return Code(code), position


def _get_code_w_scope(
    data: Any, view: Any, position: int, _obj_end: int, opts: CodecOptions[Any], element_name: str
) -> Tuple[Code, int]:
    """Decode a BSON code_w_scope to bson.code.Code."""
    code_end = position + _UNPACK_INT_FROM(data, position)[0]
    code, position = _get_string(data, view, position + 4, code_end, opts, element_name)
    scope, position = _get_object(data, view, position, code_end, opts, element_name)
    if position != code_end:
        raise InvalidBSON("scope outside of javascript code boundaries")
    return Code(code, scope), position


def _get_regex(
    data: Any, view: Any, position: int, dummy0: Any, opts: CodecOptions[Any], dummy1: Any
) -> Tuple[Regex[Any], int]:
    """Decode a BSON regex to bson.regex.Regex or a python pattern object."""
    pattern, position = _get_c_string(data, view, position, opts)
    bson_flags, position = _get_c_string(data, view, position, opts)
    bson_re = Regex(pattern, bson_flags)
    return bson_re, position


def _get_ref(
    data: Any, view: Any, position: int, obj_end: int, opts: CodecOptions[Any], element_name: str
) -> Tuple[DBRef, int]:
    """Decode (deprecated) BSON DBPointer to bson.dbref.DBRef."""
    collection, position = _get_string(data, view, position, obj_end, opts, element_name)
    oid, position = _get_oid(data, view, position, obj_end, opts, element_name)
    return DBRef(collection, oid), position


def _get_timestamp(
    data: Any, _view: Any, position: int, dummy0: Any, dummy1: Any, dummy2: Any
) -> Tuple[Timestamp, int]:
    """Decode a BSON timestamp to bson.timestamp.Timestamp."""
    inc, timestamp = _UNPACK_TIMESTAMP_FROM(data, position)
    return Timestamp(timestamp, inc), position + 8


def _get_int64(
    data: Any, _view: Any, position: int, dummy0: Any, dummy1: Any, dummy2: Any
) -> Tuple[Int64, int]:
    """Decode a BSON int64 to bson.int64.Int64."""
    return Int64(_UNPACK_LONG_FROM(data, position)[0]), position + 8

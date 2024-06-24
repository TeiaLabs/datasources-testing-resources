/**
* @description Base class for enums
*/
public virtual class SOM_BaseEnum {
    /**
    * @description Key
    */
    public String enumKey { get; set; }

    /**
    * @description Value
    */
    public String enumValue { get; set; }

    /**
    * @description Converts enum value to string
    * @return String
    */
    public override String toString() {
        return enumKey;
    }
}
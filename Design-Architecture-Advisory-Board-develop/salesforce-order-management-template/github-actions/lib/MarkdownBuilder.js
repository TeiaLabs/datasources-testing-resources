function MarkdownBuilder() {
  this.text = "";
}

MarkdownBuilder.prototype.append = function (text) {
  this.text += text;
  return this;
};

MarkdownBuilder.prototype.newLine = function (newLineCount) {
  if (!newLineCount) {
    newLineCount = 1;
  }

  return this.append("\n".repeat(newLineCount));
};

MarkdownBuilder.prototype.addCode = function (text) {
  const codeMarkdown = "`";
  return this.append(codeMarkdown).append(text).append(codeMarkdown);
};

MarkdownBuilder.prototype.addHead = function (text, headLevel) {
  const headMarkdown = "#";
  return this.append(headMarkdown.repeat(headLevel)).append(` ${text} `).append(headMarkdown);
};


MarkdownBuilder.prototype.addBlock = function (text) {
  const blockMarkdown = ">";

  return this.append(blockMarkdown).append(` ${text}`);
}

MarkdownBuilder.prototype.build = function () {
  return this.text;
}

module.exports = MarkdownBuilder;

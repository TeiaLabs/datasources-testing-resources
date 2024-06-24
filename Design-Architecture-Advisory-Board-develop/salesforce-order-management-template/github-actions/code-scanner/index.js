const path = require("path");
const core = require("@actions/core");
const github = require("@actions/github");
const MarkdownBuilder = require("../lib/MarkdownBuilder");
const sfdx = require("../lib/sfdx");

(async () => {
  const owner = core.getInput("owner", { required: true });
  const repo = core.getInput("repo", { required: true });
  const pr_number = core.getInput("pr_number", { required: true });
  const token = core.getInput("token", { required: true });

  const octokit = github.getOctokit(token);

  const pullRequest = await octokit.rest.pulls.listFiles({
    owner,
    repo,
    pull_number: pr_number,
  });

  const changedFileNames = [];
  for (const changedFile of pullRequest.data) {
    changedFileNames.push(changedFile.filename);
  }

  const scanResults = await sfdx.scanCodes(changedFileNames.join(","), path.normalize("salesforce-order-management-template/pmd-ruleset.xml"));

  const markdownBuilder = new MarkdownBuilder();
  markdownBuilder
    .addHead("PMD Scan Failed :stop_sign:", 3)
    .newLine()
    .addHead(":octocat: Please check the following violation(s):", 4)
    .newLine(2);
  let badCode = false;

  for (const scanResult of scanResults) {
    let filePath = scanResult.fileName.split("/");

    if (!filePath.includes("force-app")) {
      continue;
    }

    let fileName = filePath[filePath.length - 1];

    for (const violation of scanResult.violations) {
      badCode = true;
      markdownBuilder
        .addCode(fileName + " Line: " + violation.line + " Column :" + violation.column)
        .newLine()
        .addBlock(violation.message.replace(/\n/g, ""))
        .newLine(2);
    }
  }

  if (badCode) {
    core.setFailed(
      "PMD Scan Failed! Please check the violations in comments posted by github-actions bot and commit fixes.",
    );

    await octokit.rest.issues.createComment({
      owner,
      repo,
      issue_number: pr_number,
      body: markdownBuilder.build(),
    });
  }
})();

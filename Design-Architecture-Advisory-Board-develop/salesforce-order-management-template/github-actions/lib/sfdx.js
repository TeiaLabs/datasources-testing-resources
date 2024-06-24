const fs = require("fs");
const exec = require("@actions/exec");
const core = require("@actions/core");

const scanCodes = async (target, ruleSet) => {
  const resultFileName = "scanResults.json";

  fs.writeFileSync(resultFileName, "[]");
  
  await exec.exec("sfdx", [
    "scanner:run",
    "--target",
    target,
    "--pmdconfig",
    ruleSet,
    "--format",
    "json",
    "--outfile",
    resultFileName,
  ]);
  const scanResultsAsText = fs.readFileSync(resultFileName, "utf-8");
  const scanResultsAsJSON = JSON.parse(scanResultsAsText);

  return scanResultsAsJSON;
};

const autheticateToOrg = async (authUrl, sfdxDefaultUsername) => {
  const authFileName = "authFile.txt";
  fs.writeFileSync(authFileName, authUrl, { encoding: "utf-8" });

  let cliError = "";
  const errorHandler = function (data) {
    cliError += data.toString();
    core.setFailed(cliError);
  };

  await exec.exec(
    "sfdx",
    [
      "auth:sfdxurl:store",
      "-f",
      authFileName,
      "--setdefaultdevhubusername",
      "--setdefaultusername",
      "-a",
      sfdxDefaultUsername,
    ],
    { listeners: { stderr: errorHandler } },
  );
};

const setDefaultDevhubUsername = async (defaultDevhubUsername) => {
  let cliError = "";
  const errorHandler = function (data) {
    cliError += data.toString();
    core.setFailed(cliError);
  };

  await exec.exec("sfdx", ["force:config:set", `defaultdevhubusername=${defaultDevhubUsername}`, "-g"], {
    listeners: { stderr: errorHandler },
  });
};

const createScratchOrg = async (scratchOrgAlias) => {
  await exec.exec("sfdx", [
    "force:org:create",
    "-a",
    scratchOrgAlias,
    "-f",
    "config/project-scratch-def.json",
    "-d",
    "1",
  ]);
};

const deleteScratchOrg = async (scratchOrgAlias) => {
  let cliError = "";
  const errorHandler = function (data) {
    cliError += data.toString();
    core.setFailed(cliError);
  };

  await exec.exec("sfdx", ["force:org:delete", "-u", scratchOrgAlias, "-p"], {
    listeners: { stderr: errorHandler },
  });
};

const pushCodeToOrg = async (orgAlias) => {
  let cliError = "";
  let pushResult = "";

  const errorHandler = function (data) {
    cliError += data.toString();
    core.setFailed(cliError);
  };

  const successHandler = function (data) {
    pushResult += data.toString();
  };

  await exec.exec("sfdx", ["force:source:push", "-u", orgAlias, "--json"], {
    listeners: { stderr: errorHandler, stdout: successHandler },
  });

  return JSON.parse(pushResult);
};

module.exports = {
  scanCodes: scanCodes,
  autheticateToOrg: autheticateToOrg,
  setDefaultDevhubUsername: setDefaultDevhubUsername,
  createScratchOrg: createScratchOrg,
  deleteScratchOrg: deleteScratchOrg,
  pushCodeToOrg: pushCodeToOrg,
};

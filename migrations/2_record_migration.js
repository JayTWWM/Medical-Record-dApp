let RecordTracker = artifacts.require("./RecordTracker.sol");

module.exports = function(deployer) {
  deployer.deploy(RecordTracker);
};

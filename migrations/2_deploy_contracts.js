const KeepRandomBeacon = artifacts.require("./KeepRandomBeacon.sol");
const KeepRandomBeaconStub = artifacts.require("./KeepRandomBeaconStub.sol");
const CallbackContract = artifacts.require("./CallbackContract.sol");

module.exports = function(deployer) {
  deployer.deploy(KeepRandomBeaconStub)
    .then(function() {
      return deployer.deploy(KeepRandomBeacon, KeepRandomBeaconStub.address);
    }).then(function() {
      return deployer.deploy(CallbackContract);
    });
};

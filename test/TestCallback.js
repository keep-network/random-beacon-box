const Proxy = artifacts.require('./KeepRandomBeacon.sol');
const KeepRandomBeacon = artifacts.require('./KeepRandomBeaconStub.sol');
const CallbackContract = artifacts.require('./CallbackContract.sol');

contract('TestCallback', function() {
  let impl, proxy, keepRandomBeacon, callbackContract;

  beforeEach(async () => {
    impl = await KeepRandomBeacon.new();
    proxy = await Proxy.new(impl.address);
    keepRandomBeacon = await KeepRandomBeacon.at(proxy.address);
    await keepRandomBeacon.initialize();
    callbackContract = await CallbackContract.new();
  });

  it("should successfully call method on a callback contract", async function() {
    // Request random number and instruct to call your contract's method by
    // providing method signature as a string "callback(uint256)".
    await keepRandomBeacon.requestRelayEntry(0, 0, callbackContract.address, "callback(uint256)");

    // Get generated random value from the event emitted by KeepRandomBeacon.
    let requestResponse = (await keepRandomBeacon.getPastEvents())[1].args['requestResponse']
    let result = await callbackContract.randomNumber();
    assert.isTrue(result.eq(requestResponse), "Value updated by the callback should be the same emitted by KeepRandomBeacon.");
  });
});

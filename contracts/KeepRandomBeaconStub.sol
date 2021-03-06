pragma solidity ^0.5.4;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";


/**
 * @title KeepRandomBeaconStub
 * @dev A simplified random beacon contract to help local development. It
 * returns mocked response straight after calling `requestRelayEntry`
 */
contract KeepRandomBeaconStub is Ownable {

    // These are the public events that are used by clients
    event RelayEntryRequested(uint256 requestID, uint256 payment, uint256 blockReward, uint256 seed, uint blockNumber); 
    event RelayEntryGenerated(uint256 requestID, uint256 requestResponse, uint256 requestGroupID, uint256 previousEntry, uint blockNumber);
    event RelayResetEvent(uint256 lastValidRelayEntry, uint256 lastValidRelayTxHash, uint256 lastValidRelayBlock);
    event SubmitGroupPublicKeyEvent(byte[] groupPublicKey, uint256 requestID, uint256 activationBlockHeight);

    uint256 internal _seq;
    uint256 internal _previousEntry;
    mapping (string => bool) internal _initialized;

    /**
     * @dev Prevent receiving ether without explicitly calling a function.
     */
    function() external payable {
        revert("Can not call contract without explicitly calling a function.");
    }

    /**
     * @dev Initialize Keep Random Beacon implementation contract.
     */
    function initialize()
        public
        onlyOwner
    {
        require(!initialized(), "Contract is already initialized.");
        _initialized["KeepRandomBeaconStub"] = true;
    }

    /**
     * @dev Checks if this contract is initialized.
     */
    function initialized() public view returns (bool) {
        return _initialized["KeepRandomBeaconStub"];
    }

    /**
     * @dev Stub method to simulate successful request to generate a new relay entry,
     * which will include a random number (by signing the previous entry's random number).
     * @param blockReward The value in KEEP for generating the signature.
     * @param seed Initial seed random value from the client. It should be a cryptographically generated random value.
     * @param callbackContract Callback contract address.
     * @param callbackMethod Callback contract method signature.
     * @return An uint256 representing uniquely generated ID. It is also returned as part of the event.
     */
    function requestRelayEntry(
        uint256 blockReward,
        uint256 seed,
        address callbackContract,
        string memory callbackMethod
    ) public payable returns (uint256 requestID) {
        requestID = _seq++;
        emit RelayEntryRequested(requestID, msg.value, blockReward, seed, block.number);

        // Return mocked data instead of interacting with relay.
        uint256 groupSignature = uint256(keccak256(abi.encodePacked(_previousEntry, block.timestamp, seed)));
        uint256 groupID = uint256(keccak256(abi.encodePacked(block.timestamp, uint(1))));
        emit RelayEntryGenerated(requestID, groupSignature, groupID, _previousEntry, block.number);

        _previousEntry = groupSignature;

        // Mocked callback for demo purposes
        if (callbackContract != address(0)) {
            (bool result, ) = callbackContract.call(abi.encodeWithSignature(callbackMethod, groupSignature));
            require(result, "Require successful callback.");
        }

        return requestID;
    }

    /**
     * @dev Returns implementation version.
     */
    function version() public pure returns (string memory) {
        return "V1";
    }
}

pragma solidity ^0.5.4;


/**
 * @title CallbackContract
 * @dev Example callback contract for Random Beacon.
 */
contract CallbackContract {

    uint256 internal _randomNumber;

    /**
     * @dev Example of a callback method. Method signature can be
     * calculated as bytes4(keccak256("callback(uint256)")
    */
    function callback(uint256 requestResponse)
        public
    {
        _randomNumber = requestResponse;
    }

    /**
     * @dev Returns previously set random number.
     */
    function randomNumber() public view returns (uint256)
    {
        return _randomNumber;
    }
}

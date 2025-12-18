// Get funds from users
// Withdraw funds to owner
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// solhint-disable-next-line interface-starts-with-i
interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(uint80 _roundId) 
    external 
    view 
    returns (
        uint80 roundId, 
        int256 answer, 
        uint256 startedAt, 
        uint256 updatedAt, 
        uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

contract FundMe {
    uint256 public minimumUsd = 5;

    // in order for a function to receive native blockchain token like ethereum, you need to mark that function as payable
    function fund() public payable {
        // Allow users to send $
        // Have a minimum $ sent. $5.
        // 1. How do we send ETH to this contract?

        // require forces a transaction to do something, fail if that specified thing wasnt done.
        // in require down below, if first section is false then go ahead and revert with whatever is on the second section
        require(msg.value >= minimumUsd /*1*/, "didn't send enough eth" /*2*/); //docs.soliditylang.org msg.value: number of wei sent with the message

        // reverted transaction undoes everything done before
        // if you send a reverted transaction you will still spend gas
    }

    //function withdraw() public {}

    function getPrice() public {
        // address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI
    }
    function getConversionRate() public {}

    function getVersion() public view returns (uint256){
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}

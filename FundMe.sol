// Get funds from users
// Withdraw funds to owner
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";


error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;
    // 21,508 gas - immutable / 23,644 - non-immutable

    constructor() {
        i_owner = msg.sender;
    }

    // in order for a function to receive native blockchain token like ethereum, you need to mark that function as payable
    function fund() public payable {
        // Allow users to send $
        // Have a minimum $ sent. $5.
        // 1. How do we send ETH to this contract?
        // require forces a transaction to do something, fail if that specified thing wasnt done.
        // in require down below, if first section is false then go ahead and revert with whatever is on the second section
        require(msg.value.getConversionRate() >= MINIMUM_USD /*1*/, "didn't send enough ETH" /*2*/); 
        //msg.value will be the first parameter in getConversionRate. 2 parement if there is one is in '()'
        
        //docs.soliditylang.org msg.value: number of wei sent with the message
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] + addressToAmountFunded[msg.sender] + msg.value;
        // reverted transaction undoes everything done before
        // if you send a reverted transaction you will still spend gas
    }

    function withdraw() public onlyOwner {

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        //reset the array
        funders = new address[](0);
        //actually withdraw the funds

        //transfer 
        //payable(msg.sender).transfer(address(this).balance); // transfer revets transaction if fails
        //send
        //bool sendSuccess = payable(msg.sender).send(address(this).balance); // sends bools if was successful or not
        //require(sendSuccess, "Send Fai        led");

        //call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}(""); // send and transfer ethereum
        require(callSuccess, "Call Failed"); //code is the correct way

        
    }

    modifier onlyOwner() {
        //require(msg.sender == i_owner, "Sender is not owner!");
        //if statements save more gas than requires
        //if statements are new in solidity, this code below is new solidity syntax
        if(msg.sender != i_owner) { revert NotOwner(); }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
     }
 }

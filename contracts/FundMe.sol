// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConvertor.sol";

contract FundMe {
    using PriceConvertor for uint256;

    uint256 public minimumUsd = 50;

    // we want to keep track of all the people who send us money
    address[] public funders;
    mapping (address => uint256) public addressToAmountFunded;

    function fundMe() public payable {
        // Want to be able to set a minimum fund amount in USD
        // 1. How do we send ETH to this contract
        // we have to convert msg.value to usd equivalent in order to figure out if it is greate thant minimumUsd
        // require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough");
        require(msg.value.getConversionRate() >= minimumUsd, "Didn't send enough"); // msg.value acts like the first parameter of getConversionRate mehtod
        // msg.value has 18 decimal.

        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the array
        funders = new address[](0);
    }
}
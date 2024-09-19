// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

// import interface from "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol" 

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    uint256 public minimumUsd = 50;

    function fundMe() public payable {
        // Want to be able to set a minimum fund amount in USD
        // 1. How do we send ETH to this contract
        // we have to convert msg.value to usd equivalent in order to figure out if it is greate thant minimumUsd
        require(msg.value >= minimumUsd, "Didn't send enough");
    }

    // get the price of ethereum
    function getPrice() public {
        // we need to use chain link data feeds
        // since this is a instance of us interacting with contract outside of the project we need two thigs
        // 1. ABI of the contract
        // 2. Address of the contract =>  get from "https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1#sepolia-testnet"
        // address 0x694AA1769357215DE4FAC081bf1f309aDC325306
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306); // contract address of ethereum => usd
        return priceFeed.version();
    }
    
    function getConversionRate() public {}
}
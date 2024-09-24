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
        require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough");
        // msg.value has 18 decimal 
    }

    // get the price of ethereum
    function getPrice() public view returns(uint256) {
        // we need to use chain link data feeds
        // since this is a instance of us interacting with contract outside of the project we need two thigs
        // 1. ABI of the contract
        // 2. Address of the contract =>  get from "https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1#sepolia-testnet"
        // address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306); // contract address of ethereum => usd
        // the interface gives us some methods to use
        (,int256 answer,,,) = priceFeed.latestRoundData();  // price of Eth in USD (has 8 decimal)
        return uint256(answer * 1e10); // msg.value has 18 decimals, answer has 8 decimals so we should times it to 1e10;
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306); // contract address of ethereum => usd
        return priceFeed.version();
    }
    
    // convert the msg.value frim ethereum to terms of dollors
    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
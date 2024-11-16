# Remox Fund Me

## Introduction

For this project, we will be using two contracts: `FundMe`, the main crowdfunding contract, and `PriceConverter`. They function much like _Kickstarter_, allowing users to **send** any native blockchain cryptocurrency. They also enable the owner of the contract to **withdraw** all the funds collected. We will then deploy these contracts on a **testnet**.

> 🗒️ **NOTE**: <br />
> Use testnet sparingly. Limiting testnet transactions helps prevent network congestion, ensuring a smoother testing experience for everyone.

### fund and withdraw

Once `FundMe` is deployed on Remix, you'll notice a set of _functions_, including a new red button labelled `fund`, indicating that the function is _payable_. A payable function allows you to send native blockchain currency (e.g., Ethereum, Polygon, Avalanche) to the contract.

We'll additionally indicate a **minimum USD amount** to send to the contract when the function `fund` is called. To transfer funds to the `FundMe` contract, you can navigate to the _value section_ of the Remix deployment tab, enter a value (e.g. 0.1 ether) then hit `fund`. A MetaMask transaction confirmation will appear, and the contract balance will remain zero until the transaction is finalized. Once completed, the contract balance will be updated to reflect the transferred amount.

The contract owner can then `withdraw` the funds. In this case, since we own the contract, the balance will be removed from the contract's balance and transferred to our wallet.

## Project Setup

Let's begin by coding `FundMe`, a crowdfunding contract allowing users to send funds, which the owner can later withdraw. Before we start, let's clean up our Remix IDE workspace

### Setting up the project

Start from scratch by opening your [Remix IDE](https://remix.ethereum.org/) and deleting all existing contracts. Next, create a new contract named `FundMe`.

> 👀❗**IMPORTANT**: <br />
> Before you start coding, try to write down in plain English what you want your code to achieve. This helps clarify your goals and structure your approach.

We want `FundMe` to perform the following tasks:

1. **Allow users to send funds into the contract:** users should be able to deposit funds into the 'FundMe' contract
2. **Enable withdrawal of funds by the contract owner:** the account that owns `FundMe` should have the ability to withdraw all deposited funds
3. **Set a minimum funding value in USD:** there should be a minimum amount that can be deposited into the contract

Let's outline the core structure of the contract:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract FundMe {}
```

### fund and withdraw functions

The FundMe contract will have two primary functions that serve as the main interaction points:

1. **`fund`:** allows users to deposit funds into the contract
2. **`withdraw`:** grants the contract owner the ability to withdraw the funds that have been previously deposited

First, let's code the `fund` function and leave the `withdraw` function commented out for the moment.

```solidity
contract FundMe {
    // send funds into our contract
    function fund() public {}
    // owner can withdraw funds
    /*function withdraw() public {}*/
}
```

## Sending Eth through a function

In this part, we'll explore how to transfer Ethereum (ETH) to a smart contract by creating a `fund` function. This function will require a _minimum amount of ETH_ to ensure proper transaction handling.

### value and payable

When a transaction it's sent to the blockchain, a **value** field is always included in the _transaction data_. This field indicates the **amount** of the native cryptocurrency being transferred in that particular transaction.
For the function `fund` to be able to receive Ethereum, it must be declared **`payable`**. In the Remix UI, this keyword will turn the function red, signifying that it can accept cryptocurrency.

_Wallet addresses_ and _smart contracts_ are capable of **holding** and **managing** cryptocurrency funds. These entities can interact with the funds, perform transactions, and maintain balance records, just like a wallet.

```js
function fund() public payable {
    // allow users to send $
    // have a minimum of $ sent
    // How do we send ETH to this contract?
    msg.value;

    //function withdraw() public {}
}
```

In Solidity, the **value** of a transaction is accessible through the [`msg.value`](https://docs.soliditylang.org/en/develop/units-and-global-variables.html#special-variables-and-functions) **property**. This property is part of the _global object_ `msg`. It represents the amount of **Wei** transferred in the current transaction, where _Wei_ is the smallest unit of Ether (ETH).

### Reverting transactions

We can use the`require` keyword as a checker, to enforce our function to receive a minimum `value` of one (1) whole ether:

```js
require(msg.value > 1e18); // 1e18 = 1 ETH = 1 * 10 ** 18
```

This `require` condition ensures that the transaction meets the minimum ether requirements, allowing the function to execute only if this threshold is satisfied. If the specified requirement is not met, the transaction will **revert**.

The require statement in Solidity can include a custom error message, which is displayed if the condition isn't met, clearly explaining the cause of the transaction failure:

```js
require(msg.value > 1 ether, "Didn't send enough ETH"); //if the condition is false, revert with the error message
```

An online tool like [Ethconverter](https://eth-converter.com/) can be useful for executing conversions between _Ether_, _Wei_, and _Gwei_.

> 👀❗**IMPORTANT**: <br />
> 1 Ether = 1e9 Gwei = 1e18 Wei

> 🗒️ **NOTE**: <br />
> Gas costs are usually expressed in Gwei

If a user attempts to send less Ether than the required amount, the transaction will **fail** and a _message_ will be displayed. For example, if a user attempts to send 1000 Wei, which is significantly less than one Ether, the function will revert and does not proceed.

## Solidity Reverts

In this lesson, we will dive into how do _transaction reverts_ work, what is _gas_ where is used.

### Revert

Let's start by adding some logic to the `fund` function:

```js
 uint256 public myValue = 1;
 function fund() public {
    myValue = myValue + 2;
 }
```

A _revert_ action **undoes** all prior operations and returns the remaining gas to the transaction's sender. In this `fund` function, `myValue` increases by two (2) units with each successful execution. However, if a revert statement is encountered right after, all actions performed from the start of the function are undone. `myValue` will then reset to its initial state value, or one.

```js
 uint256 public myValue = 1;
 function fund() public {
    myValue = myValue + 2;
    require(msg.value > 1e18, "didn't send enough ETH");
    // a function revert will undo any actions that have been done.
    // It will send the remaining gas back
 }
```

### Gas Usage

> 🔥 **CAUTION**:br
> The gas used in the transaction will not be refunded if the transaction fails due to a revert statement. The gas has already been **consumed** because the code was executed by the computers, even though the transaction was ultimately reverted.

Users can specify how much gas they're willing to allocate for a transaction. In the case where the `fund` function will contain a lot of lines of code after the `require` and we did indeed set a limit, the gas which was previously allocated but not used will not be charged to the user

> 🗒️ **NOTE**:br
> If a transaction reverts, is defined as failed

### Transaction Fields

During a **value** transfer, a transaction will contain the following fields:

-   **Nonce**: transaction counter for the account
-   **Gas price (wei)**: maximum price that the sender is willing to pay _per unit of gas_
-   **Gas Limit**: maximum amount of gas the sender is willing to use for the transaction. A common value could be around 21000.
-   **To**: _recipient's address_
-   **Value (Wei)**: amount of cryptocurrency to be transferred to the recipient
-   **Data**: 🫙 _empty_
-   **v,r,s**: components of the transaction signature. They prove that the transaction is authorised by the sender.

During a _**contract interaction transaction**_, it will instead be populated with:

-   **Nonce**: transaction counter for the account
-   **Gas price (wei)**: maximum price that the sender is willing to pay _per unit of gas_
-   **Gas Limit**: maximum amount of gas the sender is willing to use for the transaction. A common value could be around 21000.
-   **To**: _address the transaction is sent to (e.g. smart contract)_
-   **Value (Wei)**: amount of cryptocurrency to be transferred to the recipient
-   **Data**: 📦 _the content to send to the_ _**To**_ _address_, e.g. a function and its parameters.
-   **v,r,s**: components of the transaction signature. They prove that the transaction is authorised by the sender.

### Conclusion

**Reverts** and **gas usage** help maintain the integrity of the blockchain state. _Reverts_ will undo transactions when failures occur, while _gas_ enables transactions execution and runs the EVM. When a transaction fails, the gas consumed is not recoverable. To manage this, Ethereum allows users to set the maximum amount of gas they're willing to pay for each transaction.

## Intro to oracles - getting real world price data

With the rapid advancement of blockchain technology and the growing adoption of decentralized finance platforms (DeFi), the necessity to support **multiple digital currencies** has significantly increased. Enabling users to utilize their preferred digital currencies extends market reach and improves the usability of an application.

This lesson will walk you through adding a **currency conversion feature** to the `fundMe` contract and setting **price thresholds** with Chainlink Oracle, a decentralized network for external data.

### USD values

Currently, our contract will require the transaction value to be greater than _one Ethereum (ETH)_. If we want to give the users the flexibility to spend instead 5 USD, we would need to update our contract. We can begin by specifying the new value with a state variable `uint256 public minimumUSD = 5` at the top of the contract.

The next step would be changing the condition inside the `fund` function, to check if the `value` sent is equal to or greater than our `minimumUSD`. However, we are facing a roadblock here: the `minimumUSD` value is in USD while the transaction message value is specified in ETH.

### Decentralized Oracles

The USD price of assets like Ethereum cannot be derived from blockchain technology alone but it is determined by the financial markets. To obtain a correct _price information_, a connection between off-chain and on-chain data is necessary. This is facilitated by a _decentralized Oracle network_.

This blockchain limitation exists because of its **deterministic nature**, ensuring that all nodes univocally reach a consensus. Attempting to introduce external data into the blockchain, will disrupt this consensus, resulting in what is referred to as a _smart contract connectivity issue_ or _the Oracle problem_.

For smart contracts to effectively replace traditional agreements, they must have the capability to interact with **real-world data**.

Relying on a centralized Oracle for data transmission is inadequate as it reintroduces potential failure points. Centralizing data sources can undermine the trust assumptions essential for the blockchain functionality. Therefore, centralized nodes are not enough for external data or computation needs. _Chainlink_ addresses these centralization challenges by offering a decentralized Oracle Network.

### How Chainlink Works

Chainlink is a _modular and decentralized Oracle Network_ that enables the integration of data and external computation into a smart contract. When a smart contract combines on-chain and off-chain data, can be defined as **hybrid** and it can create highly feature-rich applications.

Chainlink offers ready-made features that can be added to a smart contract. And we'll address some of them:

* **Data Feeds**
* **Verifiable Random Number**
* **Automation (previously known as "Keepers")**
* **Functions**

### Chainlink Data Feeds

_Chainlink Data Feeds_ are responsible for powering over \$50 billion in the DeFi world. This network of Chainlink nodes aggregates data from various **exchanges** and **data providers**, with each node independently verifying the asset price.

<img src='./images/oracle-intro-pricedata/datafeed2.png' alt='datafeed2' />

They aggregate this data and deliver it to a reference contract, the **price feed contract**, in a single transaction. Each contract will store the pricing details of a specific cryptocurrency

<img src='./images/oracle-intro-pricedata/datafeed1.png' alt='datafeed1' />

### Chainlink VRF

The Chainlink VRF (Verifiable Random Function) provides a solution for generating **provably random numbers**, ensuring true fairness in applications such as NFT randomization, lotteries, and gaming. These numbers are determined off-chain, and they are immune to manipulation.

<img src='./images/oracle-intro-pricedata/datafeed3.png' alt='datafeed3' />

### Chainlink Automation (previously known as "Keepers")

Another great feature is Chainlink's system of _Keepers_. These **nodes** listen for specific events and, upon being triggered, automatically execute the intended actions within the calling contract.

### Chainlink Function

Finally, _Chainlink Functions_ allow **API calls** to be made within a decentralized environment. This feature is ideal for creating innovative applications and is recommended for advanced users with a thorough understanding of Chainlink ecosystem.

### Conclusion

_Chainlink Data Feeds_ will help integrate currency conversion inside of our `FundMe` contract. Chainlink's decentralized Oracle network not only addresses the 'Oracle problem', but provides a suite of additional features for enhancing every dApp capabilities.
 



# old

<!--
## Sending ETH

in Deploy and run transactions section in REMIX there is an input calls "**value**", that reperesent how much ethereum we are going to be sending at our transactions.

### Transactions - Fields

1. Nonce=> tx count for the account
2. Gas Price=> price per unit of gas (in wei)
3. Gas Limit => max gas that this tx can use
4. To: address that the tx is send to
5. Value => amount of wei to send
6. Data => what to send to the To address
7. v,r,s => components of the signature [learn more](https://ethereum.stackexchange.com/questions/15766/what-does-v-r-s-in-eth-gettransactionbyhash-mean)

### Transactions - Value Transfer

1. Nonce=> tx count for the account
2. Gas Price=> price per unit of gas (in wei)
3. Gas Limit => 21000
4. To: address that the tx is send to
5. Value => amount of wei to send
6. Data => empty
7. v,r,s => components of the signature

### Transactions - Function Call

1. Nonce=> tx count for the account
2. Gas Price=> price per unit of gas (in wei)
3. Gas Limit => max gas that this tx can use
4. To => address that the tx is send to
5. Value => amount of wei to send
6. Data => what to send to the To address
7. v,r,s => components of the signature

[learn more about transactions](https://ethereum.org/en/developers/docs/transactions/);

### Payable functions

Functions and addresses declared payable can receive ether into the contract. [learn more](https://solidity-by-example.org/payable/)

```js
    function fundMe() public payable {}
```

-   smart contacts can hold funds just like how wallets can
-   when you make a function "payable" you can accees the value property

### msg

a global keyword variable that has four property. [learn more](https://docs.soliditylang.org/en/latest/cheatsheet.html#block-and-transaction-properties)

1. data (bytes): complete calldata
2. sender (address): sender of the message (current call)
3. sig (bytes4): first four bytes of the calldata (i.e. function identifier)
4. value (uint): number of wei sent with the message

### abort

abort fanction takes a condition and abort execution and revert state changes if condition is false. Also provide error message. [learn more](https://docs.soliditylang.org/en/latest/cheatsheet.html#validations-and-assertions)

```js
require(msg.value > 1e18, "didn't send enough"); // wei unit
```

-   Money math is done in terms of wei so 1 ETH nedds to be set as 1e18 value.

### reverting

undo any action before, and send remaining gas back.

```js
contract FundMe {
    uint256 public number = 0;

    function fundMe() public payable {
        number = 10; // you spend some gas for the computation, not reverting yet
        require(msg.value > 1e18, "Didn't send enough");
        number = 20; // you do not spend gas for the coputation, it is reverted
        // after the reverting the value of number variable is 0
    }
}
```

## ChainLink And Oracle

msg.value is in ETH but we want to send a value in "USD" unit. how to convert it?

There is where chainlink and oracle come into play.

### Blockchain Oracle

Blockchain oracles are entities that connect blockchains to external systems, thereby enabling smart contracts to execute based upon inputs and outputs from the real world. [learn more](https://chain.link/education/blockchain-oracles)

Any device that interfacts with the off-chian world to provide external data or computation to smart contracts.

### The Blockchain Oracle Problem

The blockchain oracle problem refers to the inability of blockchains to access external data, making them isolated networks, akin to a computer with no Internet connection. Bridging the connection between the blockchain (onchain) and the outside world (offchain) requires an additional piece of infrastructure—an oracle. [learn more](https://chain.link/education-hub/oracle-problem)

1. Smart contracts are unable to connect with external systems, data feeds, APIs, existing payment systems or any other off-chain resources on their own.
2. Centralized Oracles are a Point of Failure

### ChainLink

it is a decentralized oracle network to bring data and external computation into our smart contracts. which drives to hybrid smart contracts.

chianlink is a modular, decennterlized oracle network that can be customized to deliver any data or do any exernal computation that you like. [learn more](https://chain.link/)

### ChainLink Data Feeds

a network of chainlink nodes get data from diffrent exchanges and data providers and bring that data throght decentralized chainlink nodes. the chainlink nodes use median to figure out what the actual price of the asset is and deliver that in a single transaction to what's called a reference contract on chain that smart contracts use that pricing information to power their DEFI application. [learn more](https://docs.chain.link/data-feeds/using-data-feeds)

### ChainLink Features

1. chianlink data feeds
2. chainlink VRF (verifiable randomness function) [learn more](https://docs.chain.link/vrf)
3. chainlink keeper [learn more](https://docs.chain.link/chainlink-automation)
4. end-to-end reliability [learn more](https://docs.chain.link/any-api/get-request/introduction) [learn much more](https://docs.chain.link/any-api/introduction)

#### Other links

[Importing Tokens into your Metamask](https://consensys.io/blog/how-to-add-your-custom-tokens-in-metamask)

[Request and Receive Chainlink Model](https://docs.chain.link/architecture-overview/architecture-request-model)

## Interfaces & Price Feeds

You can interact with other contracts by declaring an Interface. [learn more](https://solidity-by-example.org/interface/)

## Importing from GitHub & NPM

[chainlink github](https://github.com/smartcontractkit/chainlink)

[chainlink npm](https://www.npmjs.com/package/@chainlink/contracts)

[AggregatorV3Interface](https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol)

## Floating Point Math in Solidity

[tuple](https://docs.soliditylang.org/en/latest/abi-spec.html#handling-tuple-types)

[Floating Point Numbers in Solidity](https://stackoverflow.com/questions/58277234/does-solidity-supports-floating-point-number)

[Type Casting](https://ethereum.stackexchange.com/questions/6891/type-casting-in-solidity)

## Basic Solidity: Arrays & Structs II

## Library

Libraries are similar to contracts, but you can't declare any state variable and you can't send ether.

A library is embedded into the contract if all library functions are internal.

Otherwise the library must be deployed and then linked before the contract is deployed.

[learn more](https://solidity-by-example.org/library/)

there is a **library** keyword that you can build a library with.

```js
    library PriceConvertor {

    }
```

all the functions in library must be internal.

### Using For

The directive using A for B; can be used to attach functions (A) as member functions to any type (B). These functions will receive the object they are called on as their first parameter (like the self variable in Python). [learn more](https://docs.soliditylang.org/en/v0.8.14/contracts.html?highlight=using#using-for)

## SafeMath, Overflow Checking, and the "unchecked" keyword

in earlier version of solidity if a number reaches the max of its value, if you add to it it will restart.

```js
    uint8 public bigNumber = 255 // the max number of uint8 is 255

    function add() public {
        bigNumber += 1; // it will restart from 0
    }
```

but if you try it in newer version it will give you an error.

to still restrart the code you need to use the "unchecked" keyword

```js
    uint8 public bigNumber = 255

    function add() public {
        unchecked {bigNumber += 1}; // it will restart from 0
    }
```

[Checked or Unchecked Arithmetic](https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic)

[Math Library](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol)

## For loop

a way to loop throgh some type of index object or some range of numbers or just do a task a certain amount of times repeating. [learn more](https://solidity-by-example.org/loop/)

```js
    // starting index, ending index, step amount
    for (uint256 i = 0; i < 10; i++) {
        if (i == 3) {
            // Skip to next iteration with continue
            continue;
        }
        if (i == 5) {
            // Exit loop with break
            break;
        }
    }
```

## Resetting an Array

you can reset an array using the below code

```js
    arrayName = new address[](0);
```

## Sending ETH from a Contract

There are 3 ways to send eth. [learn more](https://solidity-by-example.org/sending-ether/)

1. transfer

```js
// msg.sender => address
// payable(msg.sender) => payable address
payable(msg.sender).transfer(address(this).balance); // returns an error and revert if fails
```

2. send

```js
    bool sendSuccess = payable(msg.sender).send(address(this).balance); //returns a bool if fails
    require(sendSuccess, 'Send Fails');
```

3. call

```js
    (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");; // returns bool and data if fails
    require(callSuccess, 'Call Fails');
```

[learn more about this keyword](https://ethereum.stackexchange.com/questions/1781/what-is-the-this-keyword-in-solidity)

## Constructor

A constructor is an optional function that is executed upon contract creation. [learn more](https://solidity-by-example.org/constructor/)

## Modifiers

Modifiers are code that can be run before and / or after a function call. [learn more](https://solidity-by-example.org/function-modifier/)

Modifiers can be used to:

1. Restrict access
2. Validate inputs
3. Guard against reentrancy hack

```js
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _; // Underscore is a special character only used inside a function modifier and it tells Solidity to execute the rest of the code.
    }

    function changeOwner(address _newOwner) public onlyOwner (_newOwner) {
        owner = _newOwner;
    }
```

## Constant

Constants are variables that cannot be modified. Their value is hard coded and using constants can save gas cost. [learn more](https://solidity-by-example.org/constants/)

better to use upercase for constant variables.

```js
contract Constants {
    // coding convention to uppercase constant variables
    address public constant MY_ADDRESS = 0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;
    uint256 public constant MY_UINT = 123;
}
```

## Immutable

Immutable variables are like constants. Values of immutable variables can be set inside the constructor but cannot be modified afterwards. [learn more](https://solidity-by-example.org/immutable/)

```js
contract Immutable {
    // coding convention to uppercase constant variables
    address public immutable MY_ADDRESS;
    uint256 public immutable MY_UINT;

    constructor(uint256 _myUint) {
        MY_ADDRESS = msg.sender;
        MY_UINT = _myUint;
    }
}
```

## Custom Errors

Custom errors are defined using the **error** statement, which can be used inside and outside of contracts (including interfaces and libraries). [learn more](https://soliditylang.org/blog/2021/04/21/custom-errors/)

```js
error Unauthorized();

contract VendingMachine {
    address payable owner = payable(msg.sender);

    function withdraw() public {
        if (msg.sender != owner) revert Unauthorized();

        owner.transfer(address(this).balance);
    }
}
```

## Receive and Fullback functions

1. Receive functions => The receive function is executed on a call to the contract with empty calldata. This is the function that is executed on plain Ether transfers (e.g. via .send() or .transfer()). If no such function exists, but a payable fallback function exists, the fallback function will be called on a plain Ether transfer. If neither a receive Ether nor a payable fallback function is present, the contract cannot receive Ether through a transaction that does not represent a payable function call and throws an exception. [learn more](https://docs.soliditylang.org/en/latest/contracts.html#receive-ether-function)

2. Fallback function => The fallback function is executed on a call to the contract if none of the other functions match the given function signature, or if no data was supplied at all and there is no receive Ether function. The fallback function always receives data, but in order to also receive Ether it must be marked payable. [learn more](https://docs.soliditylang.org/en/latest/contracts.html#fallback-function)

```
    Explainer from: https://solidity-by-example.org/fallback/
    Ether is sent to contract
         is msg.data empty?
             /   \
            yes  no
            /     \
       receive()?  fallback()
        /   \
      yes   no
     /        \
   receive()  fallback()
``` -->

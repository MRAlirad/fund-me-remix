## Fund Me

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
    (bool callSuccess, bytes memory data) = payable(msg.sender).call{value: address(this)}(""); // returns bool and data if fails
    require(callSuccess, 'Call Fails');
```

[learn more about this keyword](https://ethereum.stackexchange.com/questions/1781/what-is-the-this-keyword-in-solidity)

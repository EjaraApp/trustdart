# trustdart
A dart library that can interact with the trust wallet core library.

## Install

You can install from here https://pub.dev/packages/trustdart.

## Overview

For every blockchain, there are two groups of operations, those that can be done locally and those that require access to a node.

### Local Operations

- Wallet management
    - Creating a new multi-coin wallet
    - Importing a multi-coin wallet
- Address derivation (receiving)
    - Generating the default address for a coin
    - Generating an address using a custom derivation path (expert)
- Transaction signing (e.g. for sending)

### Operations that require access to a node.

- Query blockchain for transaction/operations history.
- Push newly created transactions to the blockchain.

#### This libarary focuses on just the local operations. You would have to write your own code to query the blockchain or publish transactions.

#### Refere to the examples folder to see how to use test application

### Roadmap

- Add all the cryptos supported by trustwallet (this initial version only works for Tezos, Ethereum & Bitcoin)
- For Bitcoin transaction signing hasn't been implemented yet.

### Approach

- This flutter plugin makes use of method channels approach. Learn more about the approach here https://github.com/EjaraApp/trustdart/wiki/Resources.

### Contribution

- For now there are no strict guidelines.
- Just create your pull request.
- Make sure to add a description what the pull request is about.
- If you have any questions feel free to ask.
- Looking forward contributions.
# trustdart
A dart library that can interact with the trust wallet core library.


#### Adding a platform
To add platforms, run `flutter create -t plugin --platforms <platforms> .`


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
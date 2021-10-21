# trustdart
A dart library that can interact with the trust wallet core library.

## Install
- You first need to setup a personal access token for github as decribed here, https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token .
- You only need to select `read:package` scope.
- Next set the following variables in your environment 
- `TRUST_DART_GITHUB_USER` ~ the github username of the account you used to create the access token.
- `TRUST_DART_GITHUB_TOKEN` ~ the github access token you just generated.
- You can install from here https://pub.dev/packages/trustdart.

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
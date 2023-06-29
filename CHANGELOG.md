## 0.0.1

This release is a meant to be a proof of concept and to test if this can be installed in another flutter app.

## 0.0.2

Improved readme and added github access tokens for access to trustwallet android package on github maven.


### 0.0.3 

Added change logs.

### 0.0.4

Github Access Tokens Added from Dummy user

### 0.0.5

Added instructions for setting up github access tokens since dummy access token did not work. Github deletes access tokens committed to github.


### 0.0.6

Added support for TRON TOKENS, TRX, TRC10, TRC20 and Asset Freezing.


### 0.0.7

Added support for Solana, transfere and receive SOL as well as any token on Solana.

### 0.0.8

Changed return of getPrivateKey, getPublicKey to base64 encoding


### 0.0.9

Improve error handling and checking for null wallet


### 0.1.0

- Replaced `java.util.Base64` with `android.util.Base64`

- Added support for Near Crypto transfer transactions


### 0.1.1

- Fixed number conversion in Near.

### 0.1.2

- Memory optimization & minor bug fixes

### 0.1.3

- Fixed Base64 encoding issue which causes the app to crash on lower version of Android.
- Upgrade WalletCore to 3.1.31.
- Updated grade version to 7.2.1.
- added new methods on TrustDart; getSeed, getRawPrivateKey & getRawPublicKey.

### 0.1.4

- Fixed `getSeed, getRawPrivateKey & getRawPublicKey` methods returning empty array.
- Added `signDataWithPrivateKey`.


### 0.1.5

- Updated the gradle version in Android.
- Reverted to adding the feeLimit option in TRON (TRX). For instance, it provides the flexibility of setting the feeLimit to 0 for TRX send.


### 0.1.6

- Updated raw sign for tezos


### 0.1.7

- Stellar Integration

### 0.1.8

- Binance chains integrations

### 0.1.9

- Doge coin integrations

### 0.1.10

- Doge coin fixes

### 0.1.11

- Android long/int conversion issues fixed.

### 0.2.0

- Added support for tezos fa2/fa12

### 0.2.1

- Changes for Near update

### 0.3.0

- Added support for Cardano and All Ethereum / ERC20 compatible tokens and blockchains.

### 0.3.1

- Fixed bug in ethereum

### 0.3.2

- Fixed bug in cardano
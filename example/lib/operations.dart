import 'dart:typed_data';

import 'package:trustdart/trustdart.dart';
import 'package:trustdart_example/coins.dart';

Map<String, dynamic> operations = {
  'XTZ': {
    "operationList": {
      "branch": "BL8euoCWqNCny9AR3AKjnpi38haYMxjei1ZqNHuXMn19JSQnoWp",
      "operations": [
        {
          "source": "tz1XVJ8bZUXs7r5NV8dHvuiBhzECvLRLR3jW",
          "fee": 1272,
          "counter": 30738,
          "gasLimit": 10100,
          "storageLimit": 257,
          "kind": 107,
          "revealOperationData": {
            "publicKey": "8z6GkG6TaQVnpYr2gc6r8Q/mS7m0Qf6Ef9VinW8mKXM="
          }
        },
        {
          "source": "tz1XVJ8bZUXs7r5NV8dHvuiBhzECvLRLR3jW",
          "fee": 1272,
          "counter": 30739,
          "gasLimit": 10100,
          "storageLimit": 257,
          "kind": 108,
          "transactionOperationData": {
            "destination": "tz1XVJ8bZUXs7r5NV8dHvuiBhzECvLRLR3jW",
            "amount": 1
          }
        }
      ]
    }
  },
  'ETH': {
    "chainId": "AQ==",
    "gasPrice": "1pOkAA==",
    "gasLimit": "Ugg=",
    "toAddress": "0x7d8bf18C7cE84b3E175b339c4Ca93aEd1dD166F1",
    "transaction": {
      "transfer": {"amount": "A0i8paFgAA=="}
    }
  },
  'BTC': {
    // https://blockchain.info/unspent?active=35oxCr5Edc2VjoQkX65TPzxUVGXJ7r4Uny
    // https://blockchain.info/unspent?active=bc1qxjth4cj6j2v04s07au935547qk9tzd635hkt3n
    "utxos": [
      {
        "txid":
            "fce42021fd2d2fa793dc3d5d6520fc853e327e5c2c638c3a0be7529c559d3536",
        "vout": 1,
        "value": 4500,
        "script": "001434977ae25a9298fac1feef0b1a52be058ab13751",
      },
    ],
    "toAddress": "15o5bzVX58t1NRvLchBUGuHscCs1sumr2R",
    "amount": 3000,
    "fees": 1000,
    "changeAddress": "15o5bzVX58t1NRvLchBUGuHscCs1sumr2R",
    "change": 500
  },
  'TRX': {
    "cmd": "TRC20", // can be TRC20 | TRX | TRC10 | CONTRACT | FREEZE
    "ownerAddress": "TYjYrDy7yE9vyJfnF5S3EfPrzfXM3eehri", // from address
    "toAddress": "TJpQNJZSktSZQgEthhBapH3zmvg3RaCbKW", // to address
    "contractAddress":
        "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t", // in case of Trc20 (Tether USDT)
    "timestamp": DateTime.now()
        .millisecondsSinceEpoch, // current timestamp (or timestamp as at signing) milliseconds
    "amount":
        "000F4240", // 27 * 1000000, // "004C4B40", // "000F4240" = 1000000 sun hex 2's signed complement
    // (https://www.rapidtables.com/convert/number/hex-to-decimal.html)
    // for asset TRC20 | integer for any other in SUN, 1000000 SUN = 1 TRX
    "feeLimit": 10000000,
    // reference block data to be obtained by querying the blockchain
    "blockTime":
        1638519600000, // timestamp of block to be included milliseconds
    "txTrieRoot":
        "5807aea383e7de836af95c8b36e22654e4df33e5b92768e55fb936f8a7ae5304", // trie root of block
    "witnessAddress":
        "41e5e572797a3d479030e2596a239bd142a890a305", // address of witness that signed block
    "parentHash":
        "0000000002254183f6d15ba4115b3a5e8a8359adc663f7e6f02fa2bd51c07055", // parent hash of block
    "version": 23, // block version
    "number": 35996036, // block number
    // freezing
    "frozenDuration": 3, // frozen duration
    "frozenBalance": 10000000, // frozen balance in SUN
    "resource": "ENERGY", // Resource type: BANDWIDTH | ENERGY
    "assetName": "ALLOW_SAME_TOKEN_NAME"
  },
  'SOL': {
    // return {
    //   "recentBlockhash": "C6oRG8fykBeM7sL5eYyqRSZp9m2QdkGHQqtE8nTszURZ",
    //   "transferTransaction": {"recipient": "CiFADrjcd1acfVqg7hU1jpbNsdNkiUAexY9mRutsQUoR", "value": "250000"}
    // };
    "recentBlockhash": "EjUjs69fQ7JG1aHwrzMET2YqTe6PMMbtbHvCEtzvDZsJ",
    "tokenTransferTransaction": {
      "tokenMintAddress": "Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB",
      "senderTokenAddress": "7LKVpn2ZP9L7PkyFGApri9xEqUv4N8U8QCRyMHrCZqju",
      "recipientTokenAddress": "88mvV5z4gvbn7ZXcKvnCDJuoUaALis54auijidhjTbJT",
      "amount": "200000",
      "decimals": "6"
    }
  },
  'NEAR': {
    'signerID':
        '434c894cacb459ca4eeadefc7e9868c2eb68b33c0ba81f8434f2bb435b4bbb7b', // (account ID of the transaction originator)
    'receiverID':
        '434c894cacb459ca4eeadefc7e9868c2eb68b33c0ba81f8434f2bb435b4bbb7b', // (account ID of the transaction recipient)
    'nonce': 1, // (increments for every new tx)
    'amount':
        '01000000000000000000000000000000', // // uint128_t / little endian byte order
    'blockHash': '244ZQ9cgj3CQ6bWBdytfrJMuMQ1jdXLFGnr4HhvtCTnM', //
  },
  // 'XLM': {
  //   "cmd": 'Payment',
  //   "ownerAddress": "GCHYGAVOESDOZONH2UDWHTTEF3FQIZSQFBSMK3ZJ5Z5QS37TXNPN2LWI",
  //   "toAddress": "GBPT3GVKY727GYXTO6QAEVET3AW3EUVZZCZOCCO5B5PJXRVS3S4GD2AY",
  //   "asset": "USDT",
  //   "amount": 900000,
  //   "fee": 10000,
  //   "sequence": 184158241918287877,
  // },
  'XLM': {
    "cmd": 'Payment',
    "ownerAddress": "GBPT3GVKY727GYXTO6QAEVET3AW3EUVZZCZOCCO5B5PJXRVS3S4GD2AY",
    "toAddress": "GCPP3J7CE23VF3EONOIDXDL6QODYTI3YWJ7PNMHTO77WSEXGK2TT4QPV",
    "amount": 40000000,
    "fee": 10000,
    "sequence": 183629192141733900,
  },
  // 'XLM': {
  //   "cmd": "ChangeTrust",
  //   "ownerAddress":
  //       "GBPT3GVKY727GYXTO6QAEVET3AW3EUVZZCZOCCO5B5PJXRVS3S4GD2AY", //
  //   "toAddress": "GCHYGAVOESDOZONH2UDWHTTEF3FQIZSQFBSMK3ZJ5Z5QS37TXNPN2LWI", //
  //   "assetCode": "USDT",
  //   "validBefore": 1695723258,
  //   "fee": 10000,
  //   "sequence": 184070843628781573
  // }
  'BNB': {
    "chainID": "Binance-Chain-Tigris",
    "accountNumber": 7321705,
    "sequence": 2,
    "source": 0,
    "memo": "532127419",
    "fromAddress": "bnb19fy0e8m8zwqa3wn7dly7lyp9vl6ealhg4hkvtw",
    "toAddress": "bnb136ns6lfw4zs5hg4n85vdthaad7hq5m4gtkgf23",
    "amount": 10000,
  },
  'BSC': {
    "chainID": "0x38",
    "nonce": "0x01",
    "gasPrice": "0x012a05f200",
    "gasLimit": "0x5208",
    "toAddress": "0xAca4830231E74a9087EFB56a0561f8e1D87776e8",
    "amount": "0x00de0b6b3a7640",
  }
};

runOperations() async {
  // Platform messages may fail, so we use a try/catch PlatformException.
  // We also handle the message potentially returning null.
  try {
    String mnemonic = await Trustdart.generateMnemonic();
    print('Here is our mnemonic: \n$mnemonic');
    String dondo = "imitate embody law mammal exotic transfer roof hope price swift ordinary uncle";
    // dondo = "a d f d s e w q t y u l";
    bool wallet = await Trustdart.checkMnemonic(dondo);
    print(wallet);
    // https://github.com/satoshilabs/slips/blob/master/slip-0044.md
    String dataToSign =
        "03f5a22ee15cd6434751ea528328dd071738e1cfb39fb3c60d306528ff6f46b6e06c00bf43035fb548c011acf2efc84106075b8aa100038827bafcd916904ede02e80701a15985af2de2c555defbac9b8675efd9563285d400ffff07636f6c6c65637400000004008ea010";

    for (Coin coin in coinList) {
      print('Check for ${coin.code} on path ${coin.path} ...');
      print('=======================================================');
      String privKey = await Trustdart.getPrivateKey(
        dondo,
        coin.code,
        coin.path,
      );
      print('Private Key Check ...');
      print([
        privKey,
      ]);

      Uint8List rawPrivKey = await Trustdart.getRawPrivateKey(
        dondo,
        coin.code,
        coin.path,
      );
      print('Raw Private Key Check ...');
      print([
        rawPrivKey,
      ]);

      String pubKey = await Trustdart.getPublicKey(
        dondo,
        coin.code,
        coin.path,
      );
      print('Publick Key Check ...');
      print([pubKey]);

      Uint8List rawPubKey = await Trustdart.getRawPublicKey(
        dondo,
        coin.code,
        coin.path,
      );
      print('Raw Publick Key Check ...');
      print([
        rawPubKey,
      ]);

      Map address = await Trustdart.generateAddress(
        dondo,
        coin.code,
        coin.path,
      );
      print('Address Check ...');
      print([
        address,
      ]);

      Uint8List seed = await Trustdart.getSeed(
        dondo,
        coin.code,
        coin.path,
      );
      print('Seed Check ...');
      print([
        seed,
      ]);

      bool valid = await Trustdart.validateAddress(
        coin.code,
        address['legacy']!,
      );
      print([valid]);

      bool invalid = await Trustdart.validateAddress(
        coin.code,
        address['legacy']! + '0',
      );
      print('Invalid Check ...');
      print(coin.code);
      print([invalid]);

      String tx = await Trustdart.signTransaction(
        dondo,
        coin.code,
        coin.path,
        operations[coin.code],
      );
      print('Transaction Check ...');
      print([tx]);

      String signedData = (await Trustdart.signDataWithPrivateKey(
        dondo,
        coin.code,
        coin.path,
        dataToSign,
      ));
      print('Sign Data with Priv Key Check ...');
      print(signedData);
      print('');
    }
  } catch (e) {
    print(e);
  }
}

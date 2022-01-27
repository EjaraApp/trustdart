import 'package:flutter/material.dart';
import 'dart:async';
import 'package:trustdart/trustdart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

//f33e86906e93690567a58af681ceabf10fe64bb9b441fe847fd5629d6f262973

  Map _getTezosOperation() {
    return {
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
    };
  }

  Map _getEthereumOperation() {
    return {
      "chainId": "AQ==",
      "gasPrice": "1pOkAA==",
      "gasLimit": "Ugg=",
      "toAddress": "0x7d8bf18C7cE84b3E175b339c4Ca93aEd1dD166F1",
      "transaction": {
        "transfer": {"amount": "A0i8paFgAA=="}
      }
    };
  }

  Map _getBitcoinSendOperation() {
    // https://blockchain.info/unspent?active=35oxCr5Edc2VjoQkX65TPzxUVGXJ7r4Uny
    // https://blockchain.info/unspent?active=bc1qxjth4cj6j2v04s07au935547qk9tzd635hkt3n
    return {
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
    };
  }

  Map _getTronOperation() {
    return {
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
    };
  }

  Map _getSolOperation() {
    // return {
    //   "recentBlockhash": "C6oRG8fykBeM7sL5eYyqRSZp9m2QdkGHQqtE8nTszURZ",
    //   "transferTransaction": {"recipient": "CiFADrjcd1acfVqg7hU1jpbNsdNkiUAexY9mRutsQUoR", "value": "250000"}
    // };
    return {
      "recentBlockhash": "EjUjs69fQ7JG1aHwrzMET2YqTe6PMMbtbHvCEtzvDZsJ",
      "tokenTransferTransaction": {
        "tokenMintAddress": "Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB",
        "senderTokenAddress": "7LKVpn2ZP9L7PkyFGApri9xEqUv4N8U8QCRyMHrCZqju",
        "recipientTokenAddress": "88mvV5z4gvbn7ZXcKvnCDJuoUaALis54auijidhjTbJT",
        "amount": "200000",
        "decimals": "6"
      }
    };
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      String mnemonic = await Trustdart.generateMnemonic();
      print('Here is our mnemonic: \n$mnemonic');
      String dondo =
          "imitate embody law mammal exotic transfer roof hope price swift ordinary uncle";
      bool wallet = await Trustdart.checkMnemonic(dondo);
      print(wallet);
      // https://github.com/satoshilabs/slips/blob/master/slip-0044.md
      String btcPath = "m/44'/0'/0'/0/0";
      String ethPath = "m/44'/60'/0'/0/0";
      String xtzPath = "m/44'/1729'/0'/0'";
      String trxPath = "m/44'/195'/0'/0/0";
      String solPath = "m/44'/501'/0'/0/0";

      String btcPrivKey = await Trustdart.getPrivateKey(dondo, 'BTC', btcPath);
      String ethPrivKey = await Trustdart.getPrivateKey(dondo, 'ETH', ethPath);
      String xtzPrivKey = await Trustdart.getPrivateKey(dondo, 'XTZ', xtzPath);
      String trxPrivKey = await Trustdart.getPrivateKey(dondo, 'TRX', trxPath);
      String solPrivKey = await Trustdart.getPrivateKey(dondo, 'SOL', solPath);
      print([btcPrivKey, ethPrivKey, xtzPrivKey, trxPrivKey, solPrivKey]);

      String btcPubKey = await Trustdart.getPublicKey(dondo, 'BTC', btcPath);
      String ethPubKey = await Trustdart.getPublicKey(dondo, 'ETH', ethPath);
      String xtzPubKey = await Trustdart.getPublicKey(dondo, 'XTZ', xtzPath);
      String trxPubKey = await Trustdart.getPublicKey(dondo, 'TRX', trxPath);
      String solPubKey = await Trustdart.getPublicKey(dondo, 'SOL', solPath);
      print([btcPubKey, ethPubKey, xtzPubKey, trxPubKey, solPubKey]);

      Map btcAddress = await Trustdart.generateAddress(dondo, 'BTC', btcPath);
      Map ethAddress = await Trustdart.generateAddress(dondo, 'ETH', ethPath);
      Map xtzAddress = await Trustdart.generateAddress(dondo, 'XTZ', xtzPath);
      Map trxAddress = await Trustdart.generateAddress(dondo, 'TRX', trxPath);
      Map solAddress = await Trustdart.generateAddress(dondo, 'SOL', solPath);
      print([btcAddress, ethAddress, xtzAddress, trxAddress, solAddress]);

      bool isBtcLegacyValid =
          await Trustdart.validateAddress('BTC', btcAddress['legacy']);
      bool isBtcSegWitValid =
          await Trustdart.validateAddress('BTC', btcAddress['segwit']);
      bool isEthValid =
          await Trustdart.validateAddress('ETH', ethAddress['legacy']);
      bool isXtzValid =
          await Trustdart.validateAddress('XTZ', xtzAddress['legacy']);
      bool isTrxValid =
          await Trustdart.validateAddress('TRX', trxAddress['legacy']);
      bool isSolValid =
          await Trustdart.validateAddress('SOL', solAddress['legacy']);
      print([
        isBtcLegacyValid,
        isBtcSegWitValid,
        isEthValid,
        isXtzValid,
        isTrxValid,
        isSolValid
      ]);

      bool invalidBTC =
          await Trustdart.validateAddress('BTC', ethAddress['legacy']);
      bool invalidETH =
          await Trustdart.validateAddress('ETH', xtzAddress['legacy']);
      bool invalidXTZ =
          await Trustdart.validateAddress('XTZ', btcAddress['legacy']);
      bool invalidTRX =
          await Trustdart.validateAddress('TRX', btcAddress['legacy']);
      bool invalidSOL =
          await Trustdart.validateAddress('SOL', btcAddress['legacy']);
      print([invalidBTC, invalidETH, invalidXTZ, invalidTRX, invalidSOL]);

      String xtzTx = await Trustdart.signTransaction(
          dondo, 'XTZ', xtzPath, _getTezosOperation());
      String ethTx = await Trustdart.signTransaction(
          dondo, 'ETH', ethPath, _getEthereumOperation());
      String btcTx = await Trustdart.signTransaction(
          dondo, 'BTC', btcPath, _getBitcoinSendOperation());
      String trxTx = await Trustdart.signTransaction(
          dondo, 'TRX', trxPath, _getTronOperation());
      String solTx = await Trustdart.signTransaction(
          dondo, 'SOL', solPath, _getSolOperation());
      print([xtzTx, ethTx, trxTx, btcTx, solTx]);
      print(solTx);
    } catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.red,
                  primary: Colors.black,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {},
                child: const Text('Create a new multi-coin wallet'),
              ),
            ),
            Container(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.yellow,
                  primary: Colors.black,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {},
                child: const Text('Generate the default addresses.'),
              ),
            ),
            Container(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.green,
                  primary: Colors.black,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {},
                child: const Text('Sign transactions for sending.'),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

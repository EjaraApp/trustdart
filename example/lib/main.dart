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
            "revealOperationData": {"publicKey": "QpqYbIBypAofOj4qtaWBm7Gy+2mZPFAEg3gVudxVkj4="}
          },
          {
            "source": "tz1XVJ8bZUXs7r5NV8dHvuiBhzECvLRLR3jW",
            "fee": 1272,
            "counter": 30739,
            "gasLimit": 10100,
            "storageLimit": 257,
            "kind": 108,
            "transactionOperationData": {"destination": "tz1XVJ8bZUXs7r5NV8dHvuiBhzECvLRLR3jW", "amount": 1}
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
          "txid": "fce42021fd2d2fa793dc3d5d6520fc853e327e5c2c638c3a0be7529c559d3536",
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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      String mnemonic = await Trustdart.generateMnemonic();
      print('Here is our mnemonic: \n$mnemonic');
      String dondo = "imitate embody law mammal exotic transfer roof hope price swift ordinary uncle";
      bool wallet = await Trustdart.checkMnemonic(dondo);
      print(wallet);
      String btcPath = "m/44'/0'/0'/0/0";
      String ethPath = "m/44'/60'/0'/0/0";
      String xtzPath = "m/44'/1729'/0'/0'";
      String btcPrivKey = await Trustdart.getPrivateKey(mnemonic, 'BTC', btcPath);
      String ethPrivKey = await Trustdart.getPrivateKey(mnemonic, 'ETH', ethPath);
      String xtzPrivKey = await Trustdart.getPrivateKey(mnemonic, 'XTZ', xtzPath);
      print([btcPrivKey, ethPrivKey, xtzPrivKey]);
      String btcPubKey = await Trustdart.getPublicKey(mnemonic, 'BTC', btcPath);
      String ethPubKey = await Trustdart.getPublicKey(mnemonic, 'ETH', ethPath);
      String xtzPubKey = await Trustdart.getPublicKey(mnemonic, 'XTZ', xtzPath);
      print([btcPubKey, ethPubKey, xtzPubKey]);
      Map btcAddress = await Trustdart.generateAddress(mnemonic, 'BTC', btcPath);
      Map ethAddress = await Trustdart.generateAddress(mnemonic, 'ETH', ethPath);
      Map xtzAddress = await Trustdart.generateAddress(mnemonic, 'XTZ', xtzPath);
      print([btcAddress, ethAddress, xtzAddress]);
      bool isBtcLegacyValid = await Trustdart.validateAddress('BTC', btcAddress['legacy']);
      bool isBtcSegWitValid = await Trustdart.validateAddress('BTC', btcAddress['segwit']);
      bool isEthValid = await Trustdart.validateAddress('ETH', ethAddress['legacy']);
      bool isXtzValid = await Trustdart.validateAddress('XTZ', xtzAddress['legacy']);
      print([isBtcLegacyValid, isBtcSegWitValid, isEthValid, isXtzValid]);
      bool invalidBTC = await Trustdart.validateAddress('BTC', ethAddress['legacy']);
      bool invalidETH = await Trustdart.validateAddress('ETH', xtzAddress['legacy']);
      bool invalidXTZ = await Trustdart.validateAddress('XTZ', btcAddress['legacy']);
      print([invalidBTC, invalidETH, invalidXTZ]);

      String xtzTx = await Trustdart.signTransaction(mnemonic, 'XTZ', xtzPath, _getTezosOperation());
      String ethTx = await Trustdart.signTransaction(mnemonic, 'ETH', ethPath, _getEthereumOperation());
      String btcTx = await Trustdart.signTransaction(dondo, 'BTC', btcPath, _getBitcoinSendOperation());
      print([xtzTx, ethTx]);
      print([btcTx]);
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

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:trustdart/trustdart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Map _getTezosOperation() {
    return {
      "operationList": {
        "branch": "BL8euoCWqNCny9AR3AKjnpi38haYMxjei1ZqNHuXMn19JSQnoWp",
        "operations": [{
          "source": "tz1XVJ8bZUXs7r5NV8dHvuiBhzECvLRLR3jW",
          "fee": 1272,
          "counter": 30738,
          "gasLimit": 10100,
          "storageLimit": 257,
          "kind": 107,
          "revealOperationData": {
            "publicKey": "QpqYbIBypAofOj4qtaWBm7Gy+2mZPFAEg3gVudxVkj4="
          }
        }, {
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
        }]
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
        "transfer": {
          "amount":"A0i8paFgAA=="
        }
      }
    };
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await Trustdart.platformVersion ?? 'Unknown platform version';
      String mnemonic = await Trustdart.createWallet();
      print('Here is our mnemonic: \n$mnemonic');
      String dondo = "imitate embody law mammal exotic transfer roof hope price swift ordinary uncle";
      bool wallet = await Trustdart.importWalletFromMnemonic(dondo);
      print(wallet);
      String btcPath = "m/44'/0'/0'/0/0";
      String ethPath = "m/44'/60'/0'/0/0";
      String xtzPath = "m/44'/1729'/0'/0'";
      Map btcAddress = await Trustdart.generateAddressForCoin('BTC', btcPath);
      Map ethAddress = await Trustdart.generateAddressForCoin('ETH', ethPath);
      Map xtzAddress = await Trustdart.generateAddressForCoin('XTZ', xtzPath);
      print([btcAddress, ethAddress, xtzAddress]);
      bool isBtcLegacyValid = await Trustdart.validateAddressForCoin('BTC', btcAddress['legacy']);
      bool isBtcSegWitValid = await Trustdart.validateAddressForCoin('BTC', btcAddress['segwit']);
      bool isEthValid = await Trustdart.validateAddressForCoin('ETH', ethAddress['legacy']);
      bool isXtzValid = await Trustdart.validateAddressForCoin('XTZ', xtzAddress['legacy']);
      print([isBtcLegacyValid, isBtcSegWitValid, isEthValid, isXtzValid]);
      bool invalidBTC = await Trustdart.validateAddressForCoin('BTC', ethAddress['legacy']);
      bool invalidETH = await Trustdart.validateAddressForCoin('ETH', xtzAddress['legacy']);
      bool invalidXTZ = await Trustdart.validateAddressForCoin('XTZ', btcAddress['legacy']);
      print([invalidBTC, invalidETH, invalidXTZ]);

      String xtzTx = await Trustdart.buildAndSignTransaction('XTZ', xtzPath, _getTezosOperation());
      String ethTx = await Trustdart.buildAndSignTransaction('ETH', ethPath, _getEthereumOperation());
      print([xtzTx, ethTx]);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
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
          )
        ),
      ),
    );
  }
}

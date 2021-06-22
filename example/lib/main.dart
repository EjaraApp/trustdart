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
      var wallet = await Trustdart.importWalletFromMnemonic(dondo);
      print(wallet);
      var btcAddress = await Trustdart.generateAddressForCoin("m/44'/0'/0'/0/0", 'BTC');
      var ethAddress = await Trustdart.generateAddressForCoin("m/44'/60'/0'/0/0", 'ETH');
      var xtzAddress = await Trustdart.generateAddressForCoin("m/44'/1729'/0'/0'", 'XTZ');
      print([btcAddress, ethAddress, xtzAddress]);
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

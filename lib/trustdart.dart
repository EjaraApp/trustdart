import 'dart:async';

import 'package:flutter/services.dart';

/// Has static members that handle various core crypto functionalies
///
/// All the members are static and each takes care of a particular crypto
/// Interaction with the native ios/android library.
///
class Trustdart {
  static const MethodChannel _channel = const MethodChannel('trustdart');

  static Future<String> generateMnemonic([String passphrase = ""]) async {
    final String mnemonic = await _channel.invokeMethod('generateMnemonic', passphrase);
    return mnemonic;
  }

  static Future<bool> checkMnemonic(String mnemonic, [String passphrase = ""]) async {
    final bool importStatus = await _channel.invokeMethod('checkMnemonic', <String, String>{
      'mnemonic': mnemonic,
      'passphrase': passphrase,
    });
    return importStatus;
  }
/// generates an address for a particular coin
  static Future<Map> generateAddress(String mnemonic, String coin, String path, [String passphrase = ""]) async {
    final Map address = await _channel.invokeMethod('generateAddress', <String, String>{
      'coin': coin,
      'path': path,
      'mnemonic': mnemonic,
      'passphrase': passphrase,
    });
    return address;
  }
/// validates address belonging to a particular crypto
  static Future<bool> validateAddress(String coin, String address) async {
    final bool isAddressValid = await _channel.invokeMethod('validateAddress', <String, String>{
      'coin': coin,
      'address': address,
    });
    return isAddressValid;
  }

  /// Returns the hex string format of the public key.
  static Future<String> getPublicKey(String mnemonic, String coin, String path, [String passphrase = ""]) async {
    final String publicKey = await _channel.invokeMethod('getPublicKey', <String, String>{
      'coin': coin,
      'path': path,
      'mnemonic': mnemonic,
      'passphrase': passphrase,
    });
    return publicKey;
  }

  /// Returns the hex string format of the private key.
  static Future<String> getPrivateKey(String mnemonic, String coin, String path, [String passphrase = ""]) async {
    final String privateKey = await _channel.invokeMethod('getPrivateKey', <String, String>{
      'coin': coin,
      'path': path,
      'mnemonic': mnemonic,
      'passphrase': passphrase,
    });
    return privateKey;
  }

  ///signs a transaction
  static Future<String> signTransaction(String mnemonic, String coin, String path, Map txData,
      [String passphrase = ""]) async {
    final String txHash = await _channel.invokeMethod('signTransaction', <String, dynamic>{
      'coin': coin,
      'txData': txData,
      'path': path,
      'mnemonic': mnemonic,
      'passphrase': passphrase,
    });
    return txHash;
  }
}

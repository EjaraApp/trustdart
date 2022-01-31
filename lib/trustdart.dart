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
    try {
      final String mnemonic =
          await _channel.invokeMethod('generateMnemonic', passphrase);
      return mnemonic;
    } catch (e) {
      return "";
    }
  }

  static Future<bool> checkMnemonic(String mnemonic,
      [String passphrase = ""]) async {
    try {
      final bool importStatus =
          await _channel.invokeMethod('checkMnemonic', <String, String>{
        'mnemonic': mnemonic,
        'passphrase': passphrase,
      });
      return importStatus;
    } catch (e) {
      return false;
    }
  }

  /// generates an address for a particular coin
  static Future<Map> generateAddress(String mnemonic, String coin, String path,
      [String passphrase = ""]) async {
    try {
      final Map address =
          await _channel.invokeMethod('generateAddress', <String, String>{
        'coin': coin,
        'path': path,
        'mnemonic': mnemonic,
        'passphrase': passphrase,
      });
      return address;
    } catch (e) {
      return {'legacy': ''};
    }
  }

  /// validates address belonging to a particular crypto
  static Future<bool> validateAddress(String coin, String address) async {
    try {
      final bool isAddressValid =
          await _channel.invokeMethod('validateAddress', <String, String>{
        'coin': coin,
        'address': address,
      });
      return isAddressValid;
    } catch (e) {
      return false;
    }
  }

  /// Returns the hex string format of the public key.
  static Future<String> getPublicKey(String mnemonic, String coin, String path,
      [String passphrase = ""]) async {
    try {
      final String publicKey =
          await _channel.invokeMethod('getPublicKey', <String, String>{
        'coin': coin,
        'path': path,
        'mnemonic': mnemonic,
        'passphrase': passphrase,
      });
      return publicKey;
    } catch (e) {
      return '';
    }
  }

  /// Returns the hex string format of the private key.
  static Future<String> getPrivateKey(String mnemonic, String coin, String path,
      [String passphrase = ""]) async {
    try {
      final String privateKey =
          await _channel.invokeMethod('getPrivateKey', <String, String>{
        'coin': coin,
        'path': path,
        'mnemonic': mnemonic,
        'passphrase': passphrase,
      });
      return privateKey;
    } catch (e) {
      return '';
    }
  }

  ///signs a transaction
  static Future<String> signTransaction(
      String mnemonic, String coin, String path, Map txData,
      [String passphrase = ""]) async {
    try {
      final String txHash =
          await _channel.invokeMethod('signTransaction', <String, dynamic>{
        'coin': coin,
        'txData': txData,
        'path': path,
        'mnemonic': mnemonic,
        'passphrase': passphrase,
      });
      return txHash;
    } catch (e) {
      return '';
    }
  }
}

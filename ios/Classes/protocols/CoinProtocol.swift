//
//  CoinInterface.swift
//  Pods-Runner
//
//  Created by Jay on 3/29/22.
//

import WalletCore
import Flutter

protocol CoinProtocol {
    func generateAddress(path: String, mnemonic: String, passphrase: String) -> [String: String]?
    func getPrivateKey(path: String, mnemonic: String, passphrase: String) -> String?
    func getRawPrivateKey(path: String, mnemonic: String, passphrase: String) -> FlutterStandardTypedData
    func getSeed(path: String, mnemonic: String, passphrase: String) -> FlutterStandardTypedData
    func getPublicKey(path: String, mnemonic: String, passphrase: String) -> String?
    func getRawPublicKey(path: String, mnemonic: String, passphrase: String) -> FlutterStandardTypedData
    func validateAddress(address: String) -> Bool
    func signDataWithPrivateKey(path: String, mnemonic: String, passphrase: String, txData: String) -> String?
    func signTransaction(path: String, txData: [String: Any], mnemonic: String, passphrase: String) -> String?
}

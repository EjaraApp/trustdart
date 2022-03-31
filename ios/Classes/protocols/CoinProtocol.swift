//
//  CoinInterface.swift
//  Pods-Runner
//
//  Created by Jay on 3/29/22.
//

import WalletCore
import Flutter

protocol CoinProtocol {
    func generateAddress(path: String?, mnemonic: String?, passphrase: String?) -> (FlutterError? , [String: String]?)
    func generateAddress(wallet: HDWallet, path: String) -> [String: String]?
    func getPrivateKey(path: String?, mnemonic: String?, passphrase: String?) -> (FlutterError?, String?)
    func getPublicKey(path: String?, mnemonic: String?, passphrase: String?) -> (FlutterError?, String?)
    func validateAddress(address: String?) -> (FlutterError?, Bool)
    func signTransaction(path: String?, txData: [String: Any]?, mnemonic: String?, passphrase: String?) -> (FlutterError?, String?)
    func signTransaction(wallet: HDWallet, path: String, txData: [String: Any]) -> String?
}

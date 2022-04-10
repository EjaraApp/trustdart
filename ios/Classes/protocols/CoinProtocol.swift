//
//  CoinInterface.swift
//  Pods-Runner
//
//  Created by Jay on 3/29/22.
//

import WalletCore
import Flutter

protocol CoinProtocol {
    func  generateAddress(path: String, mnemonic: String, passphrase: String) -> [String: String]?
    func getPrivateKey(path: String, mnemonic: String, passphrase: String) -> String?
    func getPublicKey(path: String, mnemonic: String, passphrase: String) -> String?
    func validateAddress(address: String) -> Bool
    func signTransaction(path: String, txData: [String: Any], mnemonic: String, passphrase: String) -> String?
}

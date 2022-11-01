//
//  WalletHandler.swift
//  Pods-Runner
//
//  Created by Jay on 3/29/22.
//

import WalletCore
import Flutter

class WalletHandler {
    static let coins: [String: Coin] = [
        "BTC"   : BTC(),
        "ETH"   : ETH(),
        "XTZ"   : XTZ(),
        "TRX"   : TRX(),
        "SOL"   : SOL(),
        "NEAR"  : NEAR(),
        "XLM"   : XLM(),
    ]
    
    func getCoin(_ coin: String) -> Coin {
        return WalletHandler.coins[coin]!
    }
    
    func generateMnemonic(strength: Int32, passphrase: String) -> String? {
        return HDWallet(strength: strength, passphrase: passphrase)?.mnemonic
    }
    
    func checkMnemonic(mnemonic: String?, passphrase: String?) -> HDWallet?{
        return HDWallet(mnemonic: mnemonic!, passphrase: passphrase!)
    }
    
    static func validate<T>(walletError: WalletError, _ data: T?...) -> (Bool, WalletError) {
        var isValid = true
        data.forEach { _data in
            if _data == nil {
                isValid = false
            }
        }
        return (isValid, walletError.self)
    }
}



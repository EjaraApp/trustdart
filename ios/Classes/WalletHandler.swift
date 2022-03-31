//
//  WalletHandler.swift
//  Pods-Runner
//
//  Created by Jay on 3/29/22.
//

import WalletCore
import Flutter

class WalletHandler {
    let coins: [String: Coin]
    
    init(){
        self.coins = [
            "BTC": BTC(),
            "ETH": ETH(),
            "XTZ": XTZ(),
            "TRX": TRX(),
            "SOL": SOL()
        ]
    }
    
    func getCoin(_ coin: String) -> Coin {
        return self.coins[coin]!
    }
    
    func generateMnemonic(passphrase: String) -> (FlutterError?, String?) {
        let wallet = HDWallet(strength: 128, passphrase: passphrase)
        if wallet != nil {
            return (nil, wallet!.mnemonic)
        }else {
            return (FlutterError(code: "no_wallet",
                                message: "Could not generate wallet, why?",
                                details: nil), nil)
        }
    }
    
    func checkMnemonic(mnemonic: String?, passphrase: String?) -> (FlutterError?, Bool){
        if mnemonic != nil {
            let wallet = HDWallet(mnemonic: mnemonic!, passphrase: passphrase!)
            
            if wallet != nil {
                return (nil, true)
            } else {
                return (FlutterError(code: "no_wallet",
                                      message: "Could not generate wallet, why?",
                                      details: nil), false)
            }
        } else {
            return (FlutterError(code: "arguments_null",
                                 message: "[mnemonic] cannot be null",
                                 details: nil), false)
        }
    }
    
    
}



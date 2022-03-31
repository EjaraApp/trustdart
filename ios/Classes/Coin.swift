//
//  Coin.swift
//  Pods-Runner
//
//  Created by Jay on 3/29/22.
//
import WalletCore
import Flutter

class Coin: CoinProtocol {
    
    let name: String
    let coinType: CoinType
    
    init(name: String, coinType: CoinType){
        self.name = name
        self.coinType = coinType
    }
    
    func getName() -> String {
        return self.name
    }
    
    func generateAddress(path: String?, mnemonic: String?, passphrase: String?) -> (FlutterError? , [String: String]?) {
        if path != nil && mnemonic != nil && passphrase != nil {
            let wallet = HDWallet(mnemonic: mnemonic!, passphrase: passphrase!)
            
            if wallet != nil {
               // generate address now
                let address: [String: String]? = generateAddress(wallet: wallet!, path: path!)
                if address == nil {
                    return (FlutterError(code: "address_null",
                                         message: "Failed to generate address",
                                         details: nil), nil)
                } else {
                    return (nil, address)
                }
            }
            return (FlutterError(code: "no_wallet",
                                 message: "Could not generate wallet, why?",
                                 details: nil), nil)
        }else {
            return (FlutterError(code: "arguments_null",
                                 message: "[path], [mnemonic] and [passphrase] cannot be null",
                                 details: nil), nil)
        }
    }
    
    func generateAddress(wallet: HDWallet, path: String) -> [String: String]? {
        let privateKey = wallet.getKey(coin: self.coinType, derivationPath: path)
       return  ["legacy": CoinType.tron.deriveAddress(privateKey: privateKey)]
    }
    
    func getPrivateKey(path: String?, mnemonic: String?, passphrase: String?) -> (FlutterError?, String?) {
        if path != nil && mnemonic != nil {
            let wallet = HDWallet(mnemonic: mnemonic!, passphrase: passphrase!)
            if wallet != nil {
                let privateKey: String? = wallet!.getKey(coin: self.coinType, derivationPath: path!).data.base64EncodedString()
                if privateKey == nil {
                    return (FlutterError(code: "address_null",
                                         message: "Failed to generate address",
                                         details: nil), nil)
                } else {
                    return (nil, privateKey)
                }
            } else {
                return (FlutterError(code: "no_wallet",
                                     message: "Could not generate wallet, why?",
                                     details: nil), nil)
            }
        }else {
            return (FlutterError(code: "arguments_null",
                                 message: "[path] and [coin] and [mnemonic] cannot be null",
                                 details: nil), nil)
        }
    }
    
    
    func getPublicKey(path: String?, mnemonic: String?, passphrase: String?) -> (FlutterError?, String?) {
        if path != nil && mnemonic != nil {
            let wallet = HDWallet(mnemonic: mnemonic!, passphrase: passphrase!)
            if wallet != nil {
                let publicKey: String? = wallet!.getKey(coin: self.coinType, derivationPath: path!).getPublicKeySecp256k1(compressed: true).data.base64EncodedString()
                if publicKey == nil {
                    return (FlutterError(code: "address_null",
                                         message: "Failed to generate address",
                                         details: nil), nil)
                } else {
                    return (nil, publicKey)
                }
            } else {
                return (FlutterError(code: "no_wallet",
                                     message: "Could not generate wallet, why?",
                                     details: nil), nil)
            }
        }else {
            return (FlutterError(code: "arguments_null",
                                  message: "[path] and [mnemonic] cannot be null",
                                  details: nil), nil)
        }
    }
    
    func validateAddress(address: String?) -> (FlutterError?, Bool) {
        if address != nil {
            return (nil, self.coinType.validate(address: address!))
        }
        return (FlutterError(code: "arguments_null",
                             message: "[address] cannot be null",
                             details: nil), false)
    }

    func signTransaction(path: String?, txData: [String: Any]?, mnemonic: String?, passphrase: String?) -> (FlutterError?, String?){
        if path != nil && txData != nil && mnemonic != nil {
            let wallet = HDWallet(mnemonic: mnemonic!, passphrase: passphrase!)
            
            if wallet != nil {
                let txHash: String? = signTransaction(wallet: wallet!, path: path!, txData: txData!)
                if txHash == nil {
                    return (FlutterError(code: "txhash_null",
                                                message: "Failed to buid and sign transaction",
                                                details: nil), nil)
                } else {
                    return (nil, txHash)
                }
            } else {
                return (FlutterError(code: "no_wallet",
                                     message: "Could not generate wallet, why?",
                                     details: nil), nil)
            }
        }else {
            return (FlutterError(code: "arguments_null",
                                 message: "[path], [txData] and [mnemonic] cannot be null",
                                 details: nil), nil)
        }
    }
    
    func signTransaction(wallet: HDWallet, path: String, txData: [String: Any]) -> String? {
        let privateKey = wallet.getKey(coin: self.coinType, derivationPath: path)
        let opJson =  Utils.objToJson(from: txData)
        return AnySigner.signJSON(opJson!, key: privateKey.data, coin: self.coinType)
    }
}

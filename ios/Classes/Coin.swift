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
    
    func generateAddress(path: String, mnemonic: String, passphrase: String) -> [String: String]? {
        let privateKey =  HDWallet(mnemonic: mnemonic, passphrase: passphrase)?.getKey(coin: self.coinType, derivationPath: path)
        if privateKey != nil {
            return  ["legacy": self.coinType.deriveAddress(privateKey: privateKey!)]
        }
        return nil
    }
    
    func getPrivateKey(path: String, mnemonic: String, passphrase: String) -> String? {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        let privateKey: String? = wallet!.getKey(coin: self.coinType, derivationPath: path).data.base64EncodedString()
        return privateKey
    }
    
    func getRawPrivateKey(path: String, mnemonic: String, passphrase: String) -> [UInt8] {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        return wallet!.getKey(coin: self.coinType, derivationPath: path).data.bytes
    }
   
    func getSeed(path: String, mnemonic: String, passphrase: String) -> [UInt8] {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        return wallet!.seed.bytes
    }
    
    func getPublicKey(path: String, mnemonic: String, passphrase: String) -> String? {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        let publicKey: String? = wallet!.getKey(coin: self.coinType, derivationPath: path).getPublicKeySecp256k1(compressed: true).data.base64EncodedString()
        return publicKey
    }
    
    func getRawPublicKey(path: String, mnemonic: String, passphrase: String) -> [UInt8] {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        return wallet!.getKey(coin: self.coinType, derivationPath: path).getPublicKeySecp256k1(compressed: true).data.bytes
    }
    
    func validateAddress(address: String) -> Bool {
        return self.coinType.validate(address: address)
    }

    func signTransaction(path: String, txData: [String: Any], mnemonic: String, passphrase: String) -> String? {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        let privateKey = wallet?.getKey(coin: self.coinType, derivationPath: path)
        let opJson =  Utils.objToJson(from: txData)
        if privateKey != nil {
            return AnySigner.signJSON(opJson!, key: privateKey!.data, coin: self.coinType)
        }
        return nil
    }
}

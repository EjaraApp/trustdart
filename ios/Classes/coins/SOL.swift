//
//  SOL.swift
//  trustdart
//
//  Created by Jay on 3/29/22.
//
import WalletCore

class SOL: Coin  {
    init() {
        super.init(name: "SOL", coinType: .solana)
    }
    
    override func getPublicKey(path: String, mnemonic: String, passphrase: String) -> String? {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        let publicKey: String? = wallet!.getKey(coin: self.coinType, derivationPath: path).getPublicKeyEd25519().data.base64EncodedString()
        return publicKey
    }
}

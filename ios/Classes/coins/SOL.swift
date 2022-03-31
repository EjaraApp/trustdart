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
    
    override
    func getPublicKey(path: String?, mnemonic: String?, passphrase: String?) -> (FlutterError?, String?) {
        if path != nil && mnemonic != nil {
            let wallet = HDWallet(mnemonic: mnemonic!, passphrase: passphrase!)
            if wallet != nil {
                let publicKey: String? = wallet!.getKey(coin: self.coinType, derivationPath: path!).getPublicKeyEd25519().data.base64EncodedString()
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
}

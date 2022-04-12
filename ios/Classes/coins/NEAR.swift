/*
 NEAR
 */
import WalletCore

class NEAR: Coin  {
    init() {
        super.init(name: "NEAR", coinType: .near)
    }
    
    override func getPublicKey(path: String, mnemonic: String, passphrase: String) -> String? {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        let publicKey: String? = wallet!.getKey(coin: self.coinType, derivationPath: path).getPublicKeyEd25519().data.base64EncodedString()
        return publicKey
    }

    override func signTransaction(path: String, txData: [String : Any], mnemonic: String, passphrase: String) -> String? {
        let privateKey = HDWallet(mnemonic: mnemonic, passphrase: passphrase)?.getKey(coin: self.coinType, derivationPath: path)
        
        let input = NEARSigningInput.with {
                    $0.signerID = txData["signerID"] as! String
                    $0.nonce = txData["nonce"] as! UInt64
                    $0.receiverID = txData["receiverID"] as! String

                    $0.actions = [
                        NEARAction.with({
                            $0.transfer = NEARTransfer.with {
                                // uint128_t / little endian byte order
                                $0.deposit = Data(hexString: txData["amount"] as! String)!
                            }
                        }),
                    ]

                    $0.blockHash = Base58.decodeNoCheck(string: txData["blockHash"] as! String)!
                    $0.privateKey = privateKey!.data
                }

                let output: NEARSigningOutput = AnySigner.sign(input: input, coin: .near)
        return output.signedTransaction.hexString
    }
}

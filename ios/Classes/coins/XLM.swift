/*
 XLM
 */
import WalletCore

class XLM: Coin  {
    init() {
        super.init(name: "XLM", coinType: .stellar)
    }
    
    override func getPublicKey(path: String, mnemonic: String, passphrase: String) -> String? {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        return wallet!.getKey(coin: self.coinType, derivationPath: path).getPublicKeyEd25519().data.base64EncodedString()
    }

    override func getRawPublicKey(path: String, mnemonic: String, passphrase: String) -> FlutterStandardTypedData {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        return FlutterStandardTypedData(bytes: wallet!.getKey(coin: self.coinType, derivationPath: path).getPublicKeyEd25519().data)
    }
    
    override func signTransaction(path: String, txData: [String : Any], mnemonic: String, passphrase: String) -> String? {
        let privateKey = HDWallet(mnemonic: mnemonic, passphrase: passphrase)?.getKey(coin: self.coinType, derivationPath: path)
        let cmd = txData["cmd"] as! String
        var txHash: String?
        
        switch(cmd){
            case "ChangeTrust":
                let asset = StellarAsset.with {
                    $0.issuer = txData["toAddress"] as! String
                    $0.alphanum4 = txData["assetCode"] as! String
                }
            
                let operation = StellarOperationChangeTrust.with {
                    $0.asset = asset
                    $0.validBefore = txData["validBefore"] as! Int64
                }
            
                let signingInput = StellarSigningInput.with {
                    $0.account = txData["ownerAddress"] as! String
                    $0.fee = txData["fee"] as! Int32
                    $0.sequence = txData["sequence"] as! Int64
                    $0.passphrase = StellarPassphrase.stellar.description
                    $0.opChangeTrust = operation
                    $0.privateKey = privateKey!.data
                    if (txData["memo"] != nil) {
                        $0.memoID = StellarMemoId.with {
                            $0.id = txData["memo"] as! Int64
                        }
                    }
                }
                
                let output: StellarSigningOutput = AnySigner.sign(input: signingInput, coin: self.coinType)
                txHash = output.signature
            case "Payment":
                if (txData["asset"] != nil) {
                    let asset = StellarAsset.with {
                        $0.issuer = txData["ownerAddress"] as! String
                        $0.issuer = txData["asset"] as! String
                    }
                }
            
                let operation = StellarOperationPayment.with {
                    $0.destination = txData["toAddress"] as! String
                    $0.amount = txData["amount"] as! Int64
                    if (txData["asset"] != nil) {
                    $0.asset = asset
                    }
                }
            
                let signingInput = StellarSigningInput.with {
                    $0.account = txData["ownerAddress"] as! String
                    $0.fee = txData["fee"] as! Int32
                    $0.sequence = txData["sequence"] as! Int64
                    $0.passphrase = StellarPassphrase.stellar.description
                    $0.opPayment = operation
                    $0.privateKey = privateKey!.data
                    if (txData["memo"] != nil) {
                        $0.memoID = StellarMemoId.with {
                            $0.id = txData["memo"] as! Int64
                        }
                    }
                }
                
                let output: StellarSigningOutput = AnySigner.sign(input: signingInput, coin: self.coinType)
                txHash = output.signature

            default:
                txHash = nil
        }
        
        return txHash
    }
}

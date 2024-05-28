/*
 XLM
 */
import WalletCore

class XLM: Coin  {
    enum NetworkType: String {
        case mainnet
        case testnet
        
        var passphrase: String {
            switch self {
            case .mainnet:
                return "Public Global Stellar Network ; September 2015"
            case .testnet:
                return "Test SDF Network ; September 2015"
            }
        }
    }
    
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
        
        let networkType: NetworkType = {
            if let network = txData["network"], let type = NetworkType(rawValue: network as! String) {
                return type
            } else {
                return .mainnet // Default to mainnet if network is not provided or invalid
            }
        }()
        
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
                $0.passphrase = networkType.passphrase
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
            var asset = StellarAsset()
            if let assetString = txData["asset"] as? String, let issuer = txData["issuer"] as? String {
                asset.alphanum4 = assetString
                asset.issuer = issuer
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
                $0.passphrase = networkType.passphrase
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

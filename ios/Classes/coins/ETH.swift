/*
 ETH
 */
import WalletCore

class ETH: Coin  {
    init() {
        super.init(name: "ETH", coinType: .ethereum)
    }
    override func signTransaction(path: String, txData: [String : Any], mnemonic: String, passphrase: String) -> String? {
        let privateKey = HDWallet(mnemonic: mnemonic, passphrase: passphrase)?.getKey(coin: self.coinType, derivationPath: path)
        let cmd = txData["cmd"] as? String
        
        if privateKey != nil {
            var input = EthereumSigningInput.with {
                $0.chainID = Data(hexString: txData["chainId"] as! String)!
                $0.nonce = Data(hexString: (txData["nonce"] as! String))!
                $0.gasPrice = Data(hexString: (txData["gasPrice"] as! String))!
                $0.gasLimit = Data(hexString: (txData["gasLimit"] as! String))!
                $0.toAddress = txData["toAddress"] as! String
                $0.privateKey = privateKey!.data
            }
            switch cmd {
                case "ERC20":
                    input.toAddress = txData["contractAddress"] as! String
                    input.transaction = EthereumTransaction.with {
                        $0.erc20Transfer = EthereumTransaction.ERC20Transfer.with {
                            $0.to = txData["toAddress"] as! String
                            $0.amount = Data(hexString: (txData["amount"] as! String))!
                        }
                    }
                    
                default:
                    input.toAddress = txData["toAddress"] as! String
                    input.transaction = EthereumTransaction.with {
                        $0.transfer = EthereumTransaction.Transfer.with {
                            $0.amount = Data(hexString: (txData["amount"] as! String))!
                        }
                    }
                
            }
            let sign: EthereumSigningOutput = AnySigner.sign(input: input, coin: coinType)
            return sign.encoded.hexString
        }
        return nil
    }
}

import WalletCore

class BSC: Coin  {
    init() {
        super.init(name: "BSC", coinType: .smartChain)
    }

    override func signTransaction(path: String, txData: [String : Any], mnemonic: String, passphrase: String) -> String? {
        let privateKey = HDWallet(mnemonic: mnemonic, passphrase: passphrase)?.getKey(coin: self.coinType, derivationPath: path)

        let input = EthereumSigningInput.with {
            $0.chainID = Data(hexString: (txData["chainID"] as! String))!
            $0.nonce = Data(hexString: (txData["nonce"] as! String))! 
            $0.gasPrice = Data(hexString: (txData["gasPrice"] as! String))! 
            $0.gasLimit = Data(hexString: (txData["gasLimit"] as! String))!
            $0.toAddress = txData["toAddress"] as! String
            $0.privateKey = privateKey!.data
            $0.transaction = EthereumTransaction.with {
                $0.transfer = EthereumTransaction.Transfer.with {
                    $0.amount = Data(hexString: (txData["amount"] as! String))!
                }
            }
        }

        let sign: EthereumSigningOutput = AnySigner.sign(input: input, coin: coinType)
        return "0x"+sign.encoded.hexString

    }
}

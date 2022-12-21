import WalletCore

class BNB: Coin  {
    init() {
        super.init(name: "BNB", coinType: .binance)
    }

    override func signTransaction(path: String, txData: [String : Any], mnemonic: String, passphrase: String) -> String? {

        let privateKey = HDWallet(mnemonic: mnemonic, passphrase: passphrase)?.getKey(coin: self.coinType, derivationPath: path)
        let publicKey = privateKey?.getPublicKeySecp256k1(compressed: true)
        
        let token = BinanceSendOrder.Token.with {
            $0.denom = "BNB" // BNB or BEP2 token symbol
            $0.amount = txData["amount"] as! Int64
        }

        let orderInput = BinanceSendOrder.Input.with {
            $0.address = AnyAddress(publicKey: publicKey!, coin: .binance).data
            $0.coins = [token]
        }

        let orderOutput = BinanceSendOrder.Output.with {
            $0.address = AnyAddress(string: txData["toAddress"] as! String, coin: .binance)!.data 
            $0.coins = [token]
        }

        let input = BinanceSigningInput.with {
            $0.chainID = txData["chainID"] as! String // Chain id (network id)
            $0.accountNumber = txData["accountNumber"] as! Int64    // On chain account / address number
            $0.sequence = txData["sequence"] as! Int64  // Sequence number, plus 1 for new order
            $0.source = txData["source"] as! Int64  // BEP10 source id
            $0.privateKey = privateKey!.data
           if (txData["memo"] != nil) {
                $0.memo = txData["memo"] as! String
            }   
            $0.sendOrder = BinanceSendOrder.with {
                $0.inputs = [orderInput]
                $0.outputs = [orderOutput]
            }
        }

        let output: BinanceSigningOutput = AnySigner.sign(input: input, coin: .binance)
        return output.encoded.hexString
    }

}

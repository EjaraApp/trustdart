import WalletCore

class BNB: Coin  {
    init() {
        super.init(name: "BNB", coinType: .binance)
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
    var txHash: String?

        let privateKey = HDWallet(mnemonic: mnemonic, passphrase: passphrase)?.getKey(coin: self.coinType, derivationPath: path)
        // let publicKey = privateKey.getPublicKeySecp256k1(compressed: true)
        let publicKey = txData["fromAddress"] as! String

        let token = BinanceSendOrder.Token.with {
            $0.denom = "BNB" // BNB or BEP2 token symbol
            $0.amount = txData["amount"] as! Int64
        }

        let orderInput = BinanceSendOrder.Input.with {
            $0.address = AnyAddress(publicKey: publicKey, coin: .binance).data
            $0.coins = [token]
        }

        let orderOutput = BinanceSendOrder.Output.with {
            $0.address = txData["toAddress"] as! String
            $0.coins = [token]
        }

        let input = BinanceSigningInput.with {
            $0.chainID = txData["chainID"] as! String // Chain id (network id),                 from /v1/node-info api
            $0.accountNumber = txData["accountNumber"] as! Int64          // On chain account / address number,     from /v1/account/<address> api
            $0.sequence = txData["sequence"] as! Int64                   // Sequence number, plus 1 for new order, from /v1/account/<address> api
            $0.source = txData["source"] as! Int64                     // BEP10 source id
            $0.privateKey = privateKey.data
            // $0.memo = ""
           if (txData["memo"] != nil) {
                $0.memo = BinanceMemo.with {
                    $0.id = txData["memo"] as! Int64
                }
            }   
            $0.sendOrder = BinanceSendOrder.with {
                $0.inputs = [orderInput]
                $0.outputs = [orderOutput]
            }
        }

        let output: BinanceSigningOutput = AnySigner.sign(input: input, coin: .binance)
        txHash = output.encoded.hexString

    }

}
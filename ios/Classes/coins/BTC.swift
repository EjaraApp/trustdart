/*
 BTC
 */

import WalletCore

class BTC: Coin  {
    init() {
        super.init(name: "BTC", coinType: .bitcoin)
    }
    
    override func generateAddress(path: String, mnemonic: String, passphrase: String) -> [String : String]? {
        let privateKey =  HDWallet(mnemonic: mnemonic, passphrase: passphrase)?.getKey(coin: self.coinType, derivationPath: path)
        if privateKey != nil {
            let publicKey = privateKey!.getPublicKeySecp256k1(compressed: true)
            let legacyAddress = BitcoinAddress(publicKey: publicKey, prefix: 0)
            let scriptHashAddress = BitcoinAddress(publicKey: publicKey, prefix: 5)
            return ["legacy": legacyAddress!.description,
                    "segwit": self.coinType.deriveAddress(privateKey: privateKey!),
                    "p2sh": scriptHashAddress!.description,
            ]
        }else {
            return nil
        }
        
    }
    
    override func signTransaction(path: String, txData: [String : Any], mnemonic: String, passphrase: String) -> String? {
        let privateKey = HDWallet(mnemonic: mnemonic, passphrase: passphrase)?.getKey(coin: self.coinType, derivationPath: path)
        let utxos: [[String: Any]] = txData["utxos"] as! [[String: Any]]
        var unspent: [BitcoinUnspentTransaction] = []
        
        if privateKey != nil {
            for utx in utxos {
                unspent.append(BitcoinUnspentTransaction.with {
                    $0.outPoint.hash = Data.reverse(hexString: utx["txid"] as! String)
                    $0.outPoint.index = utx["vout"] as! UInt32
                    $0.outPoint.sequence = UINT32_MAX
                    $0.amount = utx["value"] as! Int64
                    $0.script = Data(hexString: utx["script"] as! String)!
                })
            }
            let input: BitcoinSigningInput = BitcoinSigningInput.with {
                $0.hashType = BitcoinScript.hashTypeForCoin(coinType: .bitcoin)
                $0.amount = txData["amount"] as! Int64
                $0.toAddress = txData["toAddress"] as! String
                $0.changeAddress = txData["changeAddress"] as! String // can be same sender address
                $0.privateKey = [privateKey!.data]
                $0.plan = BitcoinTransactionPlan.with {
                    $0.amount = txData["amount"] as! Int64
                    $0.fee = txData["fees"] as! Int64 
                    $0.change = txData["change"] as! Int64
                    $0.utxos = unspent
                }
            }
            
            let output: BitcoinSigningOutput = AnySigner.sign(input: input, coin: .bitcoin)
            return output.encoded.hexString
        }else {
            return nil
        }
        
    }


    
    override func multiSignTransaction(txData: [String : Any], privateKeys: [String]) -> String? {
        let utxos: [[String: Any]] = txData["utxos"] as! [[String: Any]]
        var unspent: [BitcoinUnspentTransaction] = []
        
            for utx in utxos {
                unspent.append(BitcoinUnspentTransaction.with {
                    $0.outPoint.hash = Data.reverse(hexString: utx["txid"] as! String)
                    $0.outPoint.index = utx["vout"] as! UInt32
                    $0.outPoint.sequence = UINT32_MAX
                    $0.amount = utx["value"] as! Int64
                    $0.script = Data(hexString: utx["script"] as! String)!
                })
            }
            let privateKeyDataArray = privateKeys.compactMap { privateKey in
                return Data(hexString: privateKey)
            }

            let input: BitcoinSigningInput = BitcoinSigningInput.with {
                $0.hashType = BitcoinScript.hashTypeForCoin(coinType: .bitcoin)
                $0.amount = txData["amount"] as! Int64
                $0.toAddress = txData["toAddress"] as! String
                $0.changeAddress = txData["changeAddress"] as! String // can be same sender address
                $0.privateKey = privateKeyDataArray
                $0.plan = BitcoinTransactionPlan.with {
                    $0.amount = txData["amount"] as! Int64
                    $0.fee = txData["fees"] as! Int64
                    $0.change = txData["change"] as! Int64
                    $0.utxos = unspent
                }
            }
            
            let output: BitcoinSigningOutput = AnySigner.sign(input: input, coin: .bitcoin)
            return output.encoded.hexString
        
    }

}

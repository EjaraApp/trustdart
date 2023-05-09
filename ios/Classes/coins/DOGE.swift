/*
 DOGE
 */

import WalletCore

class DOGE: Coin  {
    init() {
        super.init(name: "DOGE", coinType: .dogecoin)
    }

    override func signTransaction(path: String, txData: [String : Any], mnemonic: String, passphrase: String) -> String? {
        let privateKey = HDWallet(mnemonic: mnemonic, passphrase: passphrase)?.getKey(coin: coinType, derivationPath: path)
        let publicKey = privateKey!.getPublicKeySecp256k1(compressed: true)
        let address = BitcoinAddress(publicKey: publicKey, prefix: coinType.p2pkhPrefix)
        let script = BitcoinScript.lockScriptForAddress(address: address!.description, coin: coinType)
        let utxos: [[String: Any]] = txData["utxos"] as! [[String: Any]]
        var unspent: [BitcoinUnspentTransaction] = []
        
        if privateKey != nil {
            for utx in utxos {
                unspent.append(BitcoinUnspentTransaction.with {
                    $0.outPoint.hash = Data.reverse(hexString: utx["txid"] as! String)
                    $0.outPoint.index = UInt32(utx["vout"] as! Int)
                    $0.outPoint.sequence = UINT32_MAX
                    $0.amount = utx["value"] as! Int64
                    $0.script = script.data
                })
            }
            
            
            let input: BitcoinSigningInput = BitcoinSigningInput.with {
                $0.hashType = BitcoinScript.hashTypeForCoin(coinType: coinType)
                $0.toAddress = txData["toAddress"] as! String
                $0.changeAddress = txData["changeAddress"] as! String
                $0.privateKey = [privateKey!.data]
                $0.amount = txData["amount"] as! Int64
                $0.coinType = coinType.rawValue
                $0.byteFee = txData["fees"] as! Int64
                $0.utxo = unspent
            }
            
            let output: BitcoinSigningOutput = AnySigner.sign(input: input, coin: coinType)
            return output.encoded.hexString
        }else {
            return nil
        }
        
    }
}

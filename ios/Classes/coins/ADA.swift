/*
 ADA
 */

import WalletCore

class ADA: Coin  {
    init() {
        super.init(name: "ADA", coinType: .cardano)
    }

        override func signTransaction(path: String, txData: [String : Any], mnemonic: String, passphrase: String) -> String? {
        let privateKey = HDWallet(mnemonic: mnemonic, passphrase: passphrase)?.getKey(coin: coinType, derivationPath: path)
        let utxos: [[String: Any]] = txData["utxos"] as! [[String: Any]]
        var listOfUtxos: [CardanoTxInput] = []

        for utx in utxos {
            listOfUtxos.append(CardanoTxInput.with {
                $0.outPoint.txHash = Data(hexString: (utx["txid"] as! String))!
                $0.outPoint.outputIndex = utx["index"] as! UInt64
                $0.address = utx["senderAddress"] as! String
                $0.amount = utx["amount"] as! UInt64
            })
        }

        var input = CardanoSigningInput.with {
            $0.transferMessage.toAddress = txData["receiverAddress"] as! String
            $0.transferMessage.changeAddress =  txData["senderAddress"] as! String
            $0.transferMessage.amount = txData["amount"] as! UInt64
            $0.ttl = txData["ttl"] as! UInt64
        }
        input.privateKey.append(privateKey!.data)

        for utx in utxos {
            var utxo = CardanoTxInput.with {
                $0.outPoint.txHash = Data(hexString: (utx["txid"] as! String))!
                $0.outPoint.outputIndex = utx["index"] as! UInt64
                $0.address = utx["senderAddress"] as! String
                $0.amount = utx["balance"] as! UInt64
            }
            input.utxos.append(utxo)
        }


        let output: CardanoSigningOutput = AnySigner.sign(input: input, coin: .cardano)
        return output.encoded.hexString
        }
}

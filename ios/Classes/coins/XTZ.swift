/*
 XTZ
 */
import WalletCore

class XTZ: Coin  {
    init() {
        super.init(name: "XTZ", coinType: .tezos)
    }
    
    override func getPublicKey(path: String, mnemonic: String, passphrase: String) -> String? {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        return wallet!.getKey(coin: self.coinType, derivationPath: path).getPublicKeyEd25519().data.base64EncodedString()
    }
    
    override func getRawPublicKey(path: String, mnemonic: String, passphrase: String) -> FlutterStandardTypedData {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        return FlutterStandardTypedData(bytes: wallet!.getKey(coin: self.coinType, derivationPath: path).getPublicKeyEd25519().data)
    }
    
    override func signDataWithPrivateKey(path: String, mnemonic: String, passphrase: String, txData: String) -> String? {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        let privateKey = wallet?.getKey(coin: self.coinType, derivationPath: path)
        let hash = Hash.blake2b(data: Data(hexString: txData)!, size: 32)
        if privateKey != nil {
            return privateKey?.sign(digest: hash, curve: self.coinType.curve)?.hexString
        }
        return nil
    }

    override func signTransaction(path: String, txData: [String : Any], mnemonic: String, passphrase: String) -> String? {
        let privateKey = HDWallet(mnemonic: mnemonic, passphrase: passphrase)?.getKey(coin: self.coinType, derivationPath: path)
        let cmd = txData["cmd"] as! String
        var txHash: String?
        let branch = txData["branch"] as! String
        
        switch(cmd){
            case "FA2":
                
                var operationList = TezosOperationList()
                operationList.branch = branch
                
                let transferInfos = TezosTxs.with{
                    $0.to = txData["toAddress"] as! String
                    $0.tokenID = txData["tokenId"] as! String
                    $0.amount = txData["amount"] as! String
                }
                
                let transactionOperationData = TezosTransactionOperationData.with {
                    $0.amount =  txData["transactionAmount"] as! Int64
                    $0.destination = txData["destination"] as! String
                    $0.parameters.fa2Parameters.entrypoint = "transfer";
                    $0.parameters.fa2Parameters.txsObject = [TezosTxObject.with{
                            $0.from = txData["senderAddress"] as! String
                            $0.txs = [transferInfos]
                        }]
                }

                let transactionOperation = TezosOperation.with {
                    $0.source = txData["source"] as! String
                    $0.fee = txData["fee"] as! Int64
                    $0.counter = txData["counter"] as! Int64
                    $0.gasLimit = txData["gasLimit"] as! Int64
                    $0.storageLimit = txData["storageLimit"] as! Int64
                    $0.kind = .transaction
                    $0.transactionOperationData = transactionOperationData
                }
                
                operationList.operations = [ transactionOperation ]

                let input = TezosSigningInput.with {
                    $0.operationList = operationList
                    $0.privateKey = privateKey!.data
                }

                let output: TezosSigningOutput = AnySigner.sign(input: input, coin: .tezos)

                txHash = output.encoded.hexString
            case "FA12": 
                var operationList = TezosOperationList()
                operationList.branch = branch
                
                let transactionOperationData = TezosTransactionOperationData.with {
                    $0.amount = txData["transactionAmount"] as! Int64
                    $0.destination = txData["destination"] as! String
                    $0.parameters.fa12Parameters.entrypoint = "transfer";
                    $0.parameters.fa12Parameters.from = txData["senderAddress"] as! String;
                    $0.parameters.fa12Parameters.to   = txData["toAddress"] as! String;
                    $0.parameters.fa12Parameters.value = txData["value"] as! String;
                }
                
                let transactionOperation = TezosOperation.with {
                    $0.source = txData["source"] as! String;
                    $0.fee = txData["fee"] as! Int64
                    $0.counter = txData["counter"] as! Int64
                    $0.gasLimit = txData["gasLimit"] as! Int64
                    $0.storageLimit = txData["storageLimit"] as! Int64
                    $0.kind = .transaction
                    $0.transactionOperationData = transactionOperationData
                }
                
                operationList.operations = [ transactionOperation ]

                let input = TezosSigningInput.with {
                    $0.operationList = operationList
                    $0.privateKey = privateKey!.data
                }

                let output: TezosSigningOutput = AnySigner.sign(input: input, coin: .tezos) 
                txHash = output.encoded.hexString

            default:
            txHash = nil
        }
        
        return txHash    
        
    }
    
}

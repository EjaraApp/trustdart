//
//  TRX.swift
//  trustdart
//
//  Created by Jay on 3/29/22.
//

import WalletCore

class TRX: Coin  {
    init() {
        super.init(name: "TRX", coinType: .tron)
    }
    
    override func signTransaction(path: String, txData: [String : Any], mnemonic: String, passphrase: String) -> String? {
        let cmd = txData["cmd"] as! String
        var txHash: String?
        let privateKey = HDWallet(mnemonic: mnemonic, passphrase: passphrase)?.getKey(coin: self.coinType, derivationPath: path)
        if privateKey != nil {
            switch cmd {
            case "TRC20":
                let contract = TronTransferTRC20Contract.with {
                    $0.ownerAddress = txData["ownerAddress"] as! String
                    $0.toAddress = txData["toAddress"] as! String
                    $0.contractAddress = txData["contractAddress"] as! String
                    $0.amount = Data(hexString: txData["amount"] as! String)!
                }
                
                let input = TronSigningInput.with {
                    $0.transaction = TronTransaction.with {
                        $0.transferTrc20Contract = contract
                        $0.feeLimit = txData["feeLimit"] as! Int64
                        $0.timestamp = txData["timestamp"] as! Int64
                        $0.blockHeader = TronBlockHeader.with {
                            $0.timestamp = txData["blockTime"] as! Int64
                            $0.number = txData["number"] as! Int64
                            $0.version = txData["version"] as! Int32
                            $0.txTrieRoot = Data(hexString: txData["txTrieRoot"] as! String)!
                            $0.parentHash = Data(hexString: txData["parentHash"] as! String)!
                            $0.witnessAddress = Data(hexString: txData["witnessAddress"] as! String)!
                        }
                    }
                    $0.privateKey = privateKey!.data
                }
                let output: TronSigningOutput = AnySigner.sign(input: input, coin: self.coinType)
                txHash = output.json
            case "TRC10":
                let transferAsset = TronTransferAssetContract.with {
                    $0.ownerAddress = txData["ownerAddress"] as! String
                    $0.toAddress = txData["toAddress"] as! String
                    $0.amount = txData["amount"] as! Int64
                    $0.assetName = txData["assetName"] as! String
                }
                let input = TronSigningInput.with {
                    $0.transaction = TronTransaction.with {
                        $0.transferAsset = transferAsset
                        $0.timestamp = txData["timestamp"] as! Int64
                        $0.blockHeader = TronBlockHeader.with {
                            $0.timestamp = txData["blockTime"] as! Int64
                            $0.number = txData["number"] as! Int64
                            $0.version = txData["version"] as! Int32
                            $0.txTrieRoot = Data(hexString: txData["txTrieRoot"] as! String)!
                            $0.parentHash = Data(hexString: txData["parentHash"] as! String)!
                            $0.witnessAddress = Data(hexString: txData["witnessAddress"] as! String)!
                        }
                    }
                    $0.privateKey = privateKey!.data
                }
                let output: TronSigningOutput = AnySigner.sign(input: input, coin: self.coinType)
                txHash = output.json
            case "TRX":
                let transfer = TronTransferContract.with {
                    $0.ownerAddress = txData["ownerAddress"] as! String
                    $0.toAddress = txData["toAddress"] as! String
                    $0.amount = txData["amount"] as! Int64
                }
                let input = TronSigningInput.with {
                    $0.transaction = TronTransaction.with {
                        $0.transfer = transfer
                        $0.feeLimit = txData["feeLimit"] as! Int64
                        $0.timestamp = txData["timestamp"] as! Int64
                        $0.blockHeader = TronBlockHeader.with {
                            $0.timestamp = txData["blockTime"] as! Int64
                            $0.number = txData["number"] as! Int64
                            $0.version = txData["version"] as! Int32
                            $0.txTrieRoot = Data(hexString: txData["txTrieRoot"] as! String)!
                            $0.parentHash = Data(hexString: txData["parentHash"] as! String)!
                            $0.witnessAddress = Data(hexString: txData["witnessAddress"] as! String)!
                        }
                    }
                    $0.privateKey = privateKey!.data
                }
                let output: TronSigningOutput = AnySigner.sign(input: input, coin: self.coinType)
                txHash = output.json
            case "CONTRACT":
                txHash = ""
            case "FREEZE":
                let contract = TronFreezeBalanceContract.with {
                    $0.frozenBalance = txData["frozenBalance"] as! Int64
                    $0.frozenDuration = txData["frozenDuration"] as! Int64
                    $0.ownerAddress = txData["ownerAddress"] as! String
                    $0.resource = txData["resource"] as! String
                }
                let input = TronSigningInput.with {
                    $0.transaction = TronTransaction.with {
                        $0.freezeBalance = contract
                        $0.timestamp = txData["timestamp"] as! Int64
                        $0.blockHeader = TronBlockHeader.with {
                            $0.timestamp = txData["blockTime"] as! Int64
                            $0.number = txData["number"] as! Int64
                            $0.version = txData["version"] as! Int32
                            $0.txTrieRoot = Data(hexString: txData["txTrieRoot"] as! String)!
                            $0.parentHash = Data(hexString: txData["parentHash"] as! String)!
                            $0.witnessAddress = Data(hexString: txData["witnessAddress"] as! String)!
                        }
                    }
                    $0.privateKey = privateKey!.data
                }
                let output: TronSigningOutput = AnySigner.sign(input: input, coin: self.coinType)
                txHash = output.json
            default:
                txHash = nil
            }
            return txHash
        }
        return nil
    }
}

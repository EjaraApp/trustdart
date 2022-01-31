import Flutter
import UIKit
import WalletCore

public class SwiftTrustdartPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "trustdart", binaryMessenger: registrar.messenger())
    let instance = SwiftTrustdartPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      print(AnySigner.supportsJSON(coin: CoinType.tezos))
    switch call.method {
            case "generateMnemonic":
                let passphrase: String = call.arguments as! String
                let wallet = HDWallet(strength: 128, passphrase: passphrase)
                if wallet != nil {
                    result(wallet!.mnemonic)
                } else {
                    result(FlutterError(code: "no_wallet",
                                        message: "Could not generate wallet, why?",
                                        details: nil))
                }
            case "checkMnemonic":
                let args = call.arguments as! [String: String]
                let mnemonic: String? = args["mnemonic"]
                let passphrase: String? = args["passphrase"]
                if mnemonic != nil {
                    let wallet = HDWallet(mnemonic: mnemonic!, passphrase: passphrase!)
                    
                    if wallet != nil {
                        result(true)
                    } else {
                        result(FlutterError(code: "no_wallet",
                                            message: "Could not generate wallet, why?",
                                            details: nil))
                    }
                } else {
                    result(FlutterError(code: "arguments_null",
                                        message: "[mnemonic] cannot be null",
                                        details: nil))
                }
                
            case "generateAddress":
                let args = call.arguments as! [String: String]
                let path: String? = args["path"]
                let coin: String? = args["coin"]
                let mnemonic: String? = args["mnemonic"]
                let passphrase: String? = args["passphrase"]
                if path != nil && coin != nil && mnemonic != nil {
                    let wallet = HDWallet(mnemonic: mnemonic!, passphrase: passphrase!)
                    if wallet != nil {
                        let address: [String: String]? = generateAddress(wallet: wallet!, path: path!, coin: coin!)
                        if address == nil {
                            result(FlutterError(code: "address_null",
                                                message: "Failed to generate address",
                                                details: nil))
                        } else {
                            result(address)
                        }
                    } else {
                        result(FlutterError(code: "no_wallet",
                                            message: "Could not generate wallet, why?",
                                            details: nil))
                    }
                } else {
                    result(FlutterError(code: "arguments_null",
                                        message: "[path] and [coin] and [mnemonic] cannot be null",
                                        details: nil))
                }
            case "validateAddress":
                let args = call.arguments as! [String: String]
                let address: String? = args["address"]
                let coin: String? = args["coin"]
                if address != nil && coin != nil {
                    let isValid: Bool = validateAddress(address: address!, coin: coin!)
                    result(isValid)
                } else {
                    result(FlutterError(code: "arguments_null",
                                        message: "[address] and [coin] cannot be null",
                                        details: nil))
                }
            case "signTransaction":
                let args = call.arguments as! [String: Any]
                let coin: String? = args["coin"] as? String
                let path: String? = args["path"] as? String
                let txData: [String: Any]? = args["txData"] as? [String: Any]
                let mnemonic: String? = args["mnemonic"] as? String
                let passphrase: String? = args["passphrase"] as? String
                if coin != nil && path != nil && txData != nil && mnemonic != nil {
                    let wallet = HDWallet(mnemonic: mnemonic!, passphrase: passphrase!)
                    
                    if wallet != nil {
                        let txHash: String? = signTransaction(wallet: wallet!, coin: coin!, path: path!, txData: txData!)
                        if txHash == nil {
                            result(FlutterError(code: "txhash_null",
                                                message: "Failed to buid and sign transaction",
                                                details: nil))
                        } else {
                            result(txHash)
                        }
                    } else {
                        result(FlutterError(code: "no_wallet",
                                            message: "Could not generate wallet, why?",
                                            details: nil))
                    }
                } else {
                    result(FlutterError(code: "arguments_null",
                                        message: "[coin], [path] and [txData] cannot be null",
                                        details: nil))
                }
            case "getPublicKey":
                let args = call.arguments as! [String: String]
                let path: String? = args["path"]
                let coin: String? = args["coin"]
                let mnemonic: String? = args["mnemonic"]
                let passphrase: String? = args["passphrase"]
                if path != nil && coin != nil && mnemonic != nil {
                    let wallet = HDWallet(mnemonic: mnemonic!, passphrase: passphrase!)
                    
                    if wallet != nil {
                        let publicKey: String? = getPublicKey(wallet: wallet!, path: path!, coin: coin!)
                        if publicKey == nil {
                            result(FlutterError(code: "address_null",
                                                message: "Failed to generate address",
                                                details: nil))
                        } else {
                            result(publicKey)
                        }
                    } else {
                        result(FlutterError(code: "no_wallet",
                                            message: "Could not generate wallet, why?",
                                            details: nil))
                    }
                } else {
                    result(FlutterError(code: "arguments_null",
                                        message: "[path] and [coin] and [mnemonic] cannot be null",
                                        details: nil))
                }
            case "getPrivateKey":
                let args = call.arguments as! [String: String]
                let path: String? = args["path"]
                let coin: String? = args["coin"]
                let mnemonic: String? = args["mnemonic"]
                let passphrase: String? = args["passphrase"]
                if path != nil && coin != nil && mnemonic != nil {
                    let wallet = HDWallet(mnemonic: mnemonic!, passphrase: passphrase!)
                    
                    if wallet != nil {
                        let privateKey: String? = getPrivateKey(wallet: wallet!, path: path!, coin: coin!)
                        if privateKey == nil {
                            result(FlutterError(code: "address_null",
                                                message: "Failed to generate address",
                                                details: nil))
                        } else {
                            result(privateKey)
                        }
                    } else {
                        result(FlutterError(code: "no_wallet",
                                            message: "Could not generate wallet, why?",
                                            details: nil))
                    }
                } else {
                    result(FlutterError(code: "arguments_null",
                                        message: "[path] and [coin] and [mnemonic] cannot be null",
                                        details: nil))
                }
            default:
                result(FlutterMethodNotImplemented)
            }
  }
    
    func generateAddress(wallet: HDWallet, path: String, coin: String) -> [String: String]? {
        var addressMap: [String: String]?
        switch coin {
        case "BTC":
            let privateKey = wallet.getKey(coin: CoinType.bitcoin, derivationPath: path)
            let publicKey = privateKey.getPublicKeySecp256k1(compressed: true)
            let legacyAddress = BitcoinAddress(publicKey: publicKey, prefix: 0)
            let scriptHashAddress = BitcoinAddress(publicKey: publicKey, prefix: 5)
            addressMap = ["legacy": legacyAddress!.description,
                          "segwit": CoinType.bitcoin.deriveAddress(privateKey: privateKey),
                          "p2sh": scriptHashAddress!.description,
            ]
        case "ETH":
            let privateKey = wallet.getKey(coin: CoinType.ethereum, derivationPath: path)
            addressMap = ["legacy": CoinType.ethereum.deriveAddress(privateKey: privateKey)]
        case "XTZ":
            let privateKey = wallet.getKey(coin: CoinType.tezos, derivationPath: path)
            addressMap = ["legacy": CoinType.tezos.deriveAddress(privateKey: privateKey)]
        case "TRX":
            let privateKey = wallet.getKey(coin: CoinType.tron, derivationPath: path)
            addressMap = ["legacy": CoinType.tron.deriveAddress(privateKey: privateKey)]
        case "SOL":
            let privateKey = wallet.getKey(coin: CoinType.solana, derivationPath: path)
            addressMap = ["legacy": CoinType.solana.deriveAddress(privateKey: privateKey)]
        default:
            addressMap = nil
        }
        return addressMap
        
    }
    
    func validateAddress(address: String, coin: String) -> Bool {
        var isValid: Bool
        switch coin {
        case "BTC":
            isValid = CoinType.bitcoin.validate(address: address)
        case "ETH":
            isValid = CoinType.ethereum.validate(address: address)
        case "XTZ":
            isValid = CoinType.tezos.validate(address: address)
        case "TRX":
            isValid = CoinType.tron.validate(address: address)
        case "SOL":
            isValid = CoinType.solana.validate(address: address)
        default:
            isValid = false
        }
        return isValid

    }
    
    func getPublicKey(wallet: HDWallet, path: String, coin: String) -> String? {
        var publicKey: String?
        switch coin {
        case "BTC":
            let privateKey = wallet.getKey(coin: CoinType.bitcoin, derivationPath: path)
            publicKey = privateKey.getPublicKeySecp256k1(compressed: true).data.base64EncodedString()
        case "ETH":
            let privateKey = wallet.getKey(coin: CoinType.ethereum, derivationPath: path)
            publicKey = privateKey.getPublicKeySecp256k1(compressed: true).data.base64EncodedString()
        case "XTZ":
            let privateKey = wallet.getKey(coin: CoinType.tezos, derivationPath: path)
            publicKey = privateKey.getPublicKeyEd25519().data.base64EncodedString()
        case "TRX":
            let privateKey = wallet.getKey(coin: CoinType.tron, derivationPath: path)
            publicKey = privateKey.getPublicKeySecp256k1(compressed: true).data.base64EncodedString()
        case "SOL":
            let privateKey = wallet.getKey(coin: CoinType.solana, derivationPath: path)
            publicKey = privateKey.getPublicKeyEd25519().data.base64EncodedString()
        default:
            publicKey = nil
        }
        return publicKey;
    }
    
    func getPrivateKey(wallet: HDWallet, path: String, coin: String) -> String? {
        var privateKey: String?
        switch coin {
        case "BTC":
            privateKey = wallet.getKey(coin: CoinType.bitcoin, derivationPath: path).data.base64EncodedString()
        case "ETH":
            privateKey = wallet.getKey(coin: CoinType.ethereum, derivationPath: path).data.base64EncodedString()
        case "XTZ":
            privateKey = wallet.getKey(coin: CoinType.tezos, derivationPath: path).data.base64EncodedString()
        case "TRX":
            privateKey = wallet.getKey(coin: CoinType.tron, derivationPath: path).data.base64EncodedString()
        case "SOL":
            privateKey = wallet.getKey(coin: CoinType.solana, derivationPath: path).data.base64EncodedString()
        default:
            privateKey = nil
        }
        return privateKey;
    }
    
    func signTransaction(wallet: HDWallet, coin: String, path: String, txData: [String: Any]) -> String? {
        var txHash: String?
        switch coin {
        case "BTC":
            txHash = signBitcoinTransaction(wallet: wallet, path: path, txData: txData)
        case "ETH":
            txHash = signEthereumTransaction(wallet: wallet, path: path, txData: txData)
        case "XTZ":
            txHash = signTezosTransaction(wallet: wallet, path: path, txData: txData)
        case "TRX":
            txHash = signTronTransaction(wallet: wallet, path: path, txData: txData)
        case "SOL":
            txHash = signSolanaTransaction(wallet: wallet, path: path, txData: txData)
        default:
            txHash = nil
        }
        return txHash

    }
    
    private func objToJson(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
     func signTezosTransaction(wallet: HDWallet, path: String, txData:  [String: Any]) -> String? {
        let privateKey = wallet.getKey(coin: CoinType.tezos, derivationPath: path)
        let opJson =  objToJson(from:txData)
        let result = AnySigner.signJSON(opJson!, key: privateKey.data, coin: CoinType.tezos)
        return result
      }

    func signEthereumTransaction(wallet: HDWallet, path: String, txData:  [String: Any]) -> String? {
        let privateKey = wallet.getKey(coin: CoinType.ethereum, derivationPath: path)
        let opJson =  objToJson(from:txData)
        let result = AnySigner.signJSON(opJson!, key: privateKey.data, coin: CoinType.ethereum)
        return result
      }
    
    func signSolanaTransaction(wallet: HDWallet, path: String, txData:  [String: Any]) -> String? {
        let privateKey = wallet.getKey(coin: CoinType.solana, derivationPath: path)
        let opJson =  objToJson(from:txData)
        let result = AnySigner.signJSON(opJson!, key: privateKey.data, coin: CoinType.solana)
        return result
      }
    
    func signTronTransaction(wallet: HDWallet, path: String, txData:  [String: Any]) -> String? {
       let cmd = txData["cmd"] as! String
        print(txData)
        var txHash: String?
        let privateKey = wallet.getKey(coin: CoinType.tron, derivationPath: path)
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
                        $0.feeLimit = txData["feeLimit"] as! Int64
                        $0.transferTrc20Contract = contract
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
                    $0.privateKey = privateKey.data
                }
                let output: TronSigningOutput = AnySigner.sign(input: input, coin: CoinType.tron)
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
                $0.privateKey = privateKey.data
            }
            let output: TronSigningOutput = AnySigner.sign(input: input, coin: CoinType.tron)
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
                $0.privateKey = privateKey.data
            }
            let output: TronSigningOutput = AnySigner.sign(input: input, coin: CoinType.tron)
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
                $0.privateKey = privateKey.data
            }
            let output: TronSigningOutput = AnySigner.sign(input: input, coin: CoinType.tron)
            txHash = output.json
        default:
            txHash = nil
        }
        return txHash
    }

    func signBitcoinTransaction(wallet: HDWallet, path: String, txData:  [String: Any]) -> String? {
        let privateKey = wallet.getKey(coin: CoinType.bitcoin, derivationPath: path)
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
        let input: BitcoinSigningInput = BitcoinSigningInput.with {
            $0.hashType = BitcoinScript.hashTypeForCoin(coinType: .bitcoin)
            $0.amount = txData["amount"] as! Int64
            $0.toAddress = txData["toAddress"] as! String
            $0.changeAddress = txData["changeAddress"] as! String // can be same sender address
            $0.privateKey = [privateKey.data]
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

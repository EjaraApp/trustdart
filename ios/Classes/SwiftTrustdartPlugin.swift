import Flutter
import UIKit
import WalletCore

public class SwiftTrustdartPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "trustdart", binaryMessenger: registrar.messenger())
    let instance = SwiftTrustdartPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
    var wallet: HDWallet?

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
            case "getPlatformVersion":
                result("iOS " + UIDevice.current.systemVersion)
            case "createWallet":
                wallet = HDWallet(strength: 128, passphrase: "")
                if wallet != nil {
                    result(wallet!.mnemonic)
                } else {
                    result(FlutterError(code: "no_wallet",
                                        message: "Could not generate wallet, why?",
                                        details: nil))
                }
            case "importWalletFromMnemonic":
                let mnemonic: String = call.arguments as! String
                wallet = HDWallet(mnemonic: mnemonic, passphrase: "")
                result(true)
            case "generateAddressForCoin":
                let args = call.arguments as! [String: String]
                let path: String? = args["path"]
                let coin: String? = args["coin"]
                if path != nil && coin != nil {
                    let address: [String: String]? = generateAddressForCoin(path: path!, coin: coin!)
                    if address == nil {
                        result(FlutterError(code: "address_null",
                                            message: "Failed to generate address",
                                            details: nil))
                    } else {
                        result(address)
                    }
                } else {
                    result(FlutterError(code: "arguments_null",
                                        message: "[path] and [coin] cannot be null",
                                        details: nil))
                }
            case "validateAddressForCoin":
                let args = call.arguments as! [String: String]
                let address: String? = args["address"]
                let coin: String? = args["coin"]
                if address != nil && coin != nil {
                    let isValid: Bool = validateAddressForCoin(address: address!, coin: coin!)
                    result(isValid)
                } else {
                    result(FlutterError(code: "arguments_null",
                                        message: "[address] and [coin] cannot be null",
                                        details: nil))
                }
            case "buildAndSignTransaction":
                let args = call.arguments as! [String: Any]
                let coin: String? = args["coin"] as? String
                let path: String? = args["path"] as? String
                let txData: [String: Any]? = args["txData"] as? [String: Any]
                if coin != nil && path != nil && txData != nil {
                    let txHash: String? = buildAndSignTransaction(coin: coin!, path: path!, txData: txData!)
                    if txHash == nil {
                        result(FlutterError(code: "txhash_null",
                                            message: "Failed to buid and sign transaction",
                                            details: nil))
                    } else {
                        result(txHash)
                    }
                } else {
                    result(FlutterError(code: "arguments_null",
                                        message: "[coin], [path] and [txData] cannot be null",
                                        details: nil))
                }
            default:
                result(FlutterMethodNotImplemented)
            }
  }
    
    func generateAddressForCoin(path: String, coin: String) -> [String: String]? {
        var addressMap: [String: String]?
        switch coin {
        case "BTC":
            let privateKey = wallet!.getKey(coin: CoinType.bitcoin, derivationPath: path)
            let publicKey = privateKey.getPublicKeySecp256k1(compressed: true)
            let legacyAddress = BitcoinAddress(publicKey: publicKey, prefix: 0)
            let scriptHasgAddress = BitcoinAddress(publicKey: publicKey, prefix: 5)
            addressMap = ["legacy": legacyAddress!.description,
                          "segwit": CoinType.bitcoin.deriveAddress(privateKey: privateKey),
                          "p2sh": scriptHasgAddress!.description,
            ]
        case "ETH":
            let privateKey = wallet!.getKey(coin: CoinType.ethereum, derivationPath: path)
            addressMap = ["legacy": CoinType.ethereum.deriveAddress(privateKey: privateKey)]
        case "XTZ":
            let privateKey = wallet!.getKey(coin: CoinType.tezos, derivationPath: path)
            addressMap = ["legacy": CoinType.tezos.deriveAddress(privateKey: privateKey)]
        default:
            addressMap = nil
        }
        return addressMap
        
    }
    
    func validateAddressForCoin(address: String, coin: String) -> Bool {
        var isValid: Bool
        switch coin {
        case "BTC":
            isValid = CoinType.bitcoin.validate(address: address)
        case "ETH":
            isValid = CoinType.ethereum.validate(address: address)
        case "XTZ":
            isValid = CoinType.tezos.validate(address: address)
        default:
            isValid = false
        }
        return isValid

    }
    
    func buildAndSignTransaction(coin: String, path: String, txData: [String: Any]) -> String? {
        var txHash: String?
        switch coin {
        case "BTC":
            txHash = buildAndSignBitcoinTransaction(path: path, txData: txData)
        case "ETH":
            txHash = buildAndSignEthereumTransaction(path: path, txData: txData)
        case "XTZ":
            txHash = buildAndSignTezosTransaction(path: path, txData: txData)
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
    
     func buildAndSignTezosTransaction(path: String, txData:  [String: Any]) -> String? {
        let privateKey = wallet!.getKey(coin: CoinType.tezos, derivationPath: path)
        let opJson =  objToJson(from:txData)

        let result = AnySigner.signJSON(opJson!, key: privateKey.data, coin: CoinType.tezos)
        return result
      }

    func buildAndSignEthereumTransaction(path: String, txData:  [String: Any]) -> String? {
        let privateKey = wallet!.getKey(coin: CoinType.ethereum, derivationPath: path)
        let opJson =  objToJson(from:txData)
        let result = AnySigner.signJSON(opJson!, key: privateKey.data, coin: CoinType.ethereum)
        return result
      }

    func buildAndSignBitcoinTransaction(path: String, txData:  [String: Any]) -> String? {
        let privateKey = wallet!.getKey(coin: CoinType.bitcoin, derivationPath: path)
        return "btc"
      }
}

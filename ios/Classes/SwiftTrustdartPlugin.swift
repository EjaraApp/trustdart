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
    //print(AnySigner.supportsJSON(coin: CoinType.tezos))
    switch call.method {
            case "generateMnemonic":
                let (err, wallet) = WalletHandler().generateMnemonic(passphrase: call.arguments as! String)
                if err == nil {
                    result(wallet!)
                }else {
                    result(err!)
                }
            case "checkMnemonic":
                let args = call.arguments as! [String: String]
                let (err, isValid) = WalletHandler().checkMnemonic(mnemonic: args["mnemonic"], passphrase: args["passphrase"])
                if err == nil {
                    result(isValid)
                }else {
                    result(err!)
                }
            case "generateAddress":
                let args = call.arguments as! [String: String]
                let path: String? = args["path"]
                let coin: String? = args["coin"]
                let mnemonic: String? = args["mnemonic"]
                let passphrase: String? = args["passphrase"]
        
                let (err, address) = WalletHandler().getCoin(coin!).generateAddress(path: path, mnemonic: mnemonic, passphrase: passphrase)
                if err == nil {
                    result(address)
                }else {
                    result(err!)
                }
            case "validateAddress":
                let args = call.arguments as! [String: String]
                let address: String? = args["address"]
                let coin: String? = args["coin"]
        
                let (err, isValid) = WalletHandler().getCoin(coin!).validateAddress(address: address)
                if err == nil {
                    result(isValid)
                }else {
                    result(err!)
                }
            case "signTransaction":
                let args = call.arguments as! [String: Any]
                let coin: String? = args["coin"] as? String
                let path: String? = args["path"] as? String
                let txData: [String: Any]? = args["txData"] as? [String: Any]
                let mnemonic: String? = args["mnemonic"] as? String
                let passphrase: String? = args["passphrase"] as? String
        
                let (err, txHash) = WalletHandler().getCoin(coin!).signTransaction(path: path, txData: txData, mnemonic: mnemonic, passphrase: passphrase)
        
                if err == nil {
                    result(txHash)
                }else {
                    result(err!)
                }
            case "getPublicKey":
                let args = call.arguments as! [String: String]
                let path: String? = args["path"]
                let coin: String? = args["coin"]
                let mnemonic: String? = args["mnemonic"]
                let passphrase: String? = args["passphrase"]
        
                let (err, publicKey) = WalletHandler().getCoin(coin!).getPublicKey(path: path, mnemonic: mnemonic, passphrase: passphrase)
        
                if err == nil {
                    result(publicKey)
                }else {
                    result(err!)
                }
            case "getPrivateKey":
                let args = call.arguments as! [String: String]
                let path: String? = args["path"]
                let coin: String? = args["coin"]
                let mnemonic: String? = args["mnemonic"]
                let passphrase: String? = args["passphrase"]
        
                let (err, privateKey) = WalletHandler().getCoin(coin!).getPrivateKey(path: path, mnemonic: mnemonic, passphrase: passphrase)

                if err == nil {
                    result(privateKey)
                }else {
                    result(err!)
                }
            default:
                result(FlutterMethodNotImplemented)
            }
  }
    
}

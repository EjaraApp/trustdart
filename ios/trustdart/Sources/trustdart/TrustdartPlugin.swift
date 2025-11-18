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
        switch call.method {
        case "generateMnemonic":
            let wallet = WalletHandler().generateMnemonic(strength: 128, passphrase: call.arguments as! String)
            let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .noWallet, message: "Could not generate wallet", details: nil), wallet)
            if isValid {
                result(wallet) 
            }else {
                result(err.details)
            }
        case "checkMnemonic":
            let args = call.arguments as! [String: String]
            let wallet = WalletHandler().checkMnemonic(mnemonic: args["mnemonic"], passphrase: args["passphrase"])
            let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .argumentsNull, message: "Could not validate mnemonic", details: nil), wallet)
            if isValid {
                result(isValid)
            }else {
                result(err.details)
            }
        case "generateAddress":
            let args = call.arguments as! [String: String]
            let path: String? = args["path"]
            let coin: String? = args["coin"]
            let mnemonic: String? = args["mnemonic"]
            let passphrase: String? = args["passphrase"]
            
            let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .argumentsNull, message: ErrorResponse.addressNull, details: nil), path, coin, mnemonic, passphrase)
            if isValid {
                // generate address
                let address = WalletHandler().getCoin(coin!).generateAddress(path: path!, mnemonic: mnemonic!, passphrase: passphrase!)
                let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .addressNull, message: "Failed to generate address.", details: nil), path, coin, mnemonic, passphrase)
                if isValid {
                    result(address)
                }else {
                    result(err.details)
                }
            }else {
                result(err.details)
            }
        case "validateAddress":
            let args = call.arguments as! [String: String]
            let address: String? = args["address"]
            let coin: String? = args["coin"]
            
            let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .argumentsNull, message: "[coin] and [address] are required.", details: nil), address, coin)
            
            if isValid {
                result(WalletHandler().getCoin(coin!).validateAddress(address: address!))
            }else {
                result(err.details)
            }
        case "signTransaction":
            let args = call.arguments as! [String: Any]
            let coin: String? = args["coin"] as? String
            let path: String? = args["path"] as? String
            let txData: [String: Any]? = args["txData"] as? [String: Any]
            let mnemonic: String? = args["mnemonic"] as? String
            let passphrase: String? = args["passphrase"] as? String
            let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .argumentsNull, message: "[coin], [path], [mnemonic] and [passphrase] are required.", details: nil), coin, path, mnemonic, passphrase)
            
            if isValid {
                let txHash = WalletHandler().getCoin(coin!).signTransaction(path: path!, txData: txData!, mnemonic: mnemonic!, passphrase: passphrase!)
                
                let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .txHashNull, message: "Failed to sign transaction.", details: nil), txHash)
                if isValid {
                    result(txHash)
                }else {
                    result(err.details)
                } 
            }else {
                result(err.details)
            }
            
        case "multiSignTransaction":
            let args = call.arguments as! [String: Any]
            let coin: String? = args["coin"] as? String
            let txData: [String: Any]? = args["txData"] as? [String: Any]
            let privateKeys: [String]? = args["privateKeys"] as? [String]
            let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .argumentsNull, message: "[coin] are required.", details: nil), coin)
            
            if isValid {
                let txHash = WalletHandler().getCoin(coin!).multiSignTransaction(txData: txData!, privateKeys: privateKeys ?? [] )
                
                let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .txHashNull, message: "Failed to sign transaction.", details: nil), txHash)
                if isValid {
                    result(txHash)
                }else {
                    result(err.details)
                }
            }else {
                result(err.details)
            }

        case "signDataWithPrivateKey":
            let args = call.arguments as! [String: Any]
            let coin: String? = args["coin"] as? String
            let path: String? = args["path"] as? String
            let txData: String? = args["txData"] as? String
            let mnemonic: String? = args["mnemonic"] as? String
            let passphrase: String? = args["passphrase"] as? String
            let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .argumentsNull, message: "[coin], [path], [mnemonic] and [passphrase] are required.", details: nil), coin, path, mnemonic, passphrase)
            
            if isValid {
                let txHash = WalletHandler().getCoin(coin!).signDataWithPrivateKey(path: path!, mnemonic: mnemonic!, passphrase: passphrase!, txData: txData!)
                
                let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .txHashNull, message: "Failed to sign data.", details: nil), txHash)
                if isValid {
                    result(txHash)
                }else {
                    result(err.details)
                }
            }else {
                result(err.details)
            }
        case "getPublicKey":
            let args = call.arguments as! [String: String]
            let path: String? = args["path"]
            let coin: String? = args["coin"]
            let mnemonic: String? = args["mnemonic"]
            let passphrase: String? = args["passphrase"]
            
            let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .argumentsNull, message: ErrorResponse.addressNull, details: nil), path, coin, mnemonic, passphrase)
            if isValid {
                // generate address
                let publicKey = WalletHandler().getCoin(coin!).getPublicKey(path: path!, mnemonic: mnemonic!, passphrase: passphrase!)
                let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .addressNull, message: "Failed to generate public key.", details: nil), path, coin, mnemonic, passphrase)
                if isValid {
                    result(publicKey)
                }else {
                    result(err.details)
                }
            }else {
                result(err.details)
            }
        case "getRawPublicKey":
            let args = call.arguments as! [String: String]
            let path: String? = args["path"]
            let coin: String? = args["coin"]
            let mnemonic: String? = args["mnemonic"]
            let passphrase: String? = args["passphrase"]
            
            let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .argumentsNull, message: ErrorResponse.addressNull, details: nil), path, coin, mnemonic, passphrase)
            if isValid {
                // generate address
                let publicKey = WalletHandler().getCoin(coin!).getRawPublicKey(path: path!, mnemonic: mnemonic!, passphrase: passphrase!)
                let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .addressNull, message: "Failed to generate public key.", details: nil), path, coin, mnemonic, passphrase)
                if isValid {
                    result(publicKey)
                }else {
                    result(err.details)
                }
            }else {
                result(err.details)
            }
        case "getPrivateKey":
            let args = call.arguments as! [String: String]
            let path: String? = args["path"]
            let coin: String? = args["coin"]
            let mnemonic: String? = args["mnemonic"]
            let passphrase: String? = args["passphrase"]
            
            let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .argumentsNull, message: ErrorResponse.addressNull, details: nil), path, coin, mnemonic, passphrase)
            if isValid {
                // generate address
                let privateKey = WalletHandler().getCoin(coin!).getPrivateKey(path: path!, mnemonic: mnemonic!, passphrase: passphrase!)
                let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .addressNull, message: "Failed to generate private key.", details: nil), path, coin, mnemonic, passphrase)
                if isValid {
                    result(privateKey)
                }else {
                    result(err.details)
                }
            }else {
                result(err.details)
            }
        case "getRawPrivateKey":
            let args = call.arguments as! [String: String]
            let path: String? = args["path"]
            let coin: String? = args["coin"]
            let mnemonic: String? = args["mnemonic"]
            let passphrase: String? = args["passphrase"]
            
            let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .argumentsNull, message: ErrorResponse.addressNull, details: nil), path, coin, mnemonic, passphrase)
            if isValid {
                // generate address
                let privateKey = WalletHandler().getCoin(coin!).getRawPrivateKey(path: path!, mnemonic: mnemonic!, passphrase: passphrase!)
                let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .addressNull, message: "Failed to generate private key.", details: nil), path, coin, mnemonic, passphrase)
                if isValid {
                    result(privateKey)
                }else {
                    result(err.details)
                }
            }else {
                result(err.details)
            }
        case "getSeed":
            let args = call.arguments as! [String: String]
            let path: String? = args["path"]
            let coin: String? = args["coin"]
            let mnemonic: String? = args["mnemonic"]
            let passphrase: String? = args["passphrase"]
            
            let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .argumentsNull, message: ErrorResponse.addressNull, details: nil), path, coin, mnemonic, passphrase)
            if isValid {
                // generate address
                let privateKey = WalletHandler().getCoin(coin!).getSeed(path: path!, mnemonic: mnemonic!, passphrase: passphrase!)
                let (isValid, err) = WalletHandler.validate(walletError: WalletError(code: .addressNull, message: "Failed to generate private key.", details: nil), path, coin, mnemonic, passphrase)
                if isValid {
                    result(privateKey)
                }else {
                    result(err.details)
                }
            }else {
                result(err.details)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
}

import Flutter
import UIKit
import TrustWalletCore

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
                result(FlutterMethodNotImplemented)
            case "validateAddressForCoin":
                result(FlutterMethodNotImplemented)
            case "buildAndSignTransaction":
                result(FlutterMethodNotImplemented)
            default:
                result(FlutterMethodNotImplemented)
            }
  }
}

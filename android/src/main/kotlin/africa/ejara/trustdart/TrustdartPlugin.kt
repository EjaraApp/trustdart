package africa.ejara.trustdart

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** TrustdartPlugin */
class TrustdartPlugin : FlutterPlugin, MethodCallHandler {

    init {
        System.loadLibrary("TrustWalletCore")
    }

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "trustdart")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "generateMnemonic" -> {
                val wallet = WalletHandler().generateMnemonic(call.arguments())
                if (wallet != null) {
                    result.success(wallet)
                } else {
                    result.error(
                        "no_wallet",
                        "Could not generate wallet, why?", null
                    )
                }
            }
            "checkMnemonic" -> {
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")
                val isValid = WalletHandler().checkMnemonic(mnemonic, passphrase)
                if (isValid) {
                    result.success(true)
                } else {
                    result.error(
                        "no_wallet",
                        "Could not generate wallet, why?", null
                    )
                }
            }
            "generateAddress" -> {
                val path: String? = call.argument("path")
                val coin: String? = call.argument("coin")
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")
                val address =
                    WalletHandler().getCoin(coin).generateAddress(path, mnemonic, passphrase)
                if (address != null) {
                    result.success(address)
                } else {
                    result.error(
                        "no_wallet",
                        "Could not generate wallet, why?", null
                    )
                }
            }
            "validateAddress" -> {
                val address: String? = call.argument("address")
                val coin: String? = call.argument("coin")
                val isValid = WalletHandler().getCoin(coin).validateAddress(address)
                if (isValid != null) {
                    result.success(isValid)
                } else {
                    result.error("arguments_null", "$address and $coin cannot be null", null)
                }
            }
            "signTransaction" -> {
                val coin: String? = call.argument("coin")
                val path: String? = call.argument("path")
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")
                val txData: Map<String, Any>? = call.argument("txData")
                val txHash = WalletHandler().getCoin(coin)
                    .signTransaction(path, txData, mnemonic, passphrase)
                if (txHash != null) {
                    result.success(txHash)
                } else {
                    result.error(
                        "no_wallet",
                        "Could not generate wallet, why?", null
                    )
                }
            }
            "getPublicKey" -> {
                val path: String? = call.argument("path")
                val coin: String? = call.argument("coin")
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")
                val publicKey =
                    WalletHandler().getCoin(coin).getPublicKey(path, mnemonic, passphrase)
                if (publicKey != null) {
                    result.success(publicKey)
                } else {
                    result.error(
                        "no_wallet",
                        "Could not generate wallet, why?", null
                    )
                }
            }
            "getPrivateKey" -> {
                val path: String? = call.argument("path")
                val coin: String? = call.argument("coin")
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")
                val privateKey: String? =
                    WalletHandler().getCoin(coin).getPrivateKey(path, mnemonic, passphrase)
                if (privateKey != null) {
                    result.success(privateKey)
                } else {
                    result.error(
                        "no_wallet",
                        "Could not generate wallet, why?", null
                    )
                }
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

}

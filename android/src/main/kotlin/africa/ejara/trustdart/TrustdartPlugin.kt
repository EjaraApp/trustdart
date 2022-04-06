package africa.ejara.trustdart

import africa.ejara.trustdart.utils.WalletError
import africa.ejara.trustdart.utils.WalletHandlerErrorCodes
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import wallet.core.jni.HDWallet


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
                var validator = WalletHandler().validate<Any>(
                    WalletError(
                        WalletHandlerErrorCodes.argumentsNull,
                        "[strength] and [passphrase] are required.",
                        null
                    ), arrayOf(call.arguments())
                )
                if (validator.isValid) {
                    val wallet = WalletHandler().generateMnemonic(128, call.arguments())
                    validator = WalletHandler().validate<Any?>(
                        WalletError(
                            WalletHandlerErrorCodes.noWallet,
                            "Could not generated mnemonic.",
                            null
                        ), arrayOf(wallet)
                    )
                    if (validator.isValid) return result.success(wallet)
                }
                return result.error(
                    validator.details.errorCode,
                    validator.details.errorMessage,
                    validator.details.errorDetails
                )
            }
            "checkMnemonic" -> {
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")
                var validator = WalletHandler().validate<Any?>(
                    WalletError(
                        WalletHandlerErrorCodes.argumentsNull,
                        "[mnemonic] and [passphrase] are required.",
                        null
                    ), arrayOf(mnemonic, passphrase)
                )
                if (validator.isValid) {
                    val wallet = WalletHandler().checkMnemonic(mnemonic!!, passphrase!!)
                    validator = WalletHandler().validate<HDWallet?>(
                        WalletError(
                            WalletHandlerErrorCodes.noWallet,
                            "Failed to generate wallet.",
                            null
                        ), arrayOf(wallet)
                    )
                    if (validator.isValid) return result.success(true)
                }
                return result.error(
                    validator.details.errorCode,
                    validator.details.errorMessage,
                    validator.details.errorDetails
                )
            }
            "generateAddress" -> {
                val path: String? = call.argument("path")
                val coin: String? = call.argument("coin")
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")
                var validator = WalletHandler().validate<Any?>(
                    WalletError(
                        WalletHandlerErrorCodes.argumentsNull,
                        "[path], [coin], [mnemonic] and [passphrase] are required.",
                        null
                    ), arrayOf(path, coin, mnemonic, passphrase)
                )
                if (validator.isValid) {
                    val address = WalletHandler().getCoin(coin)
                        .generateAddress(path!!, mnemonic!!, passphrase!!)
                    validator = WalletHandler().validate(
                        WalletError(
                            WalletHandlerErrorCodes.addressNull,
                            "Could not generate address.",
                            null
                        ), arrayOf(address)
                    )
                    if (validator.isValid) return result.success(address)
                }
                return result.error(
                    validator.details.errorCode,
                    validator.details.errorMessage,
                    validator.details.errorDetails
                )
            }
            "validateAddress" -> {
                val address: String? = call.argument("address")
                val coin: String? = call.argument("coin")
                val validator = WalletHandler().validate<Any?>(
                    WalletError(
                        WalletHandlerErrorCodes.argumentsNull,
                        "[coin] and [address] are required.",
                        null
                    ), arrayOf(coin, address)
                )
                if (validator.isValid) {
                    if (WalletHandler().getCoin(coin)
                            .validateAddress(address!!)
                    ) return result.success(true)
                }
                return result.error(
                    validator.details.errorCode,
                    validator.details.errorMessage,
                    validator.details.errorDetails
                )
            }
            "signTransaction" -> {
                val coin: String? = call.argument("coin")
                val path: String? = call.argument("path")
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")
                val txData: Map<String, Any>? = call.argument("txData")
                var validator = WalletHandler().validate(
                    WalletError(
                        WalletHandlerErrorCodes.argumentsNull,
                        "[path], [coin], [mnemonic], [passphrase] and [txData] are required.",
                        null
                    ), arrayOf(path, coin, mnemonic, txData, passphrase)
                )
                if (validator.isValid) {
                    val txHash = WalletHandler().getCoin(coin)
                        .signTransaction(path!!, txData!!, mnemonic!!, passphrase!!)
                    validator = WalletHandler().validate(
                        WalletError(
                            WalletHandlerErrorCodes.txHashNull,
                            "Could not sign transaction.",
                            null
                        ), arrayOf(txHash)
                    )
                    if (validator.isValid) return result.success(txHash)
                }
                return result.error(
                    validator.details.errorCode,
                    validator.details.errorMessage,
                    validator.details.errorDetails
                )
            }
            "getPublicKey" -> {
                val path: String? = call.argument("path")
                val coin: String? = call.argument("coin")
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")

                var validator = WalletHandler().validate<Any?>(
                    WalletError(
                        WalletHandlerErrorCodes.argumentsNull,
                        "[path], [coin], [mnemonic] and [passphrase] are required.",
                        null
                    ), arrayOf(path, coin, mnemonic, passphrase)
                )
                if (validator.isValid) {
                    val publicKey =
                        WalletHandler().getCoin(coin).getPublicKey(path!!, mnemonic!!, passphrase!!)
                    validator = WalletHandler().validate(
                        WalletError(
                            WalletHandlerErrorCodes.addressNull,
                            "Could not generate public key.",
                            null
                        ), arrayOf(publicKey)
                    )
                    if (validator.isValid) return result.success(publicKey)
                }
                return result.error(
                    validator.details.errorCode,
                    validator.details.errorMessage,
                    validator.details.errorDetails
                )
            }
            "getPrivateKey" -> {
                val path: String? = call.argument("path")
                val coin: String? = call.argument("coin")
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")

                var validator = WalletHandler().validate<Any?>(
                    WalletError(
                        WalletHandlerErrorCodes.argumentsNull,
                        "[path], [coin], [mnemonic] and [passphrase] are required.",
                        null
                    ), arrayOf(path, coin, mnemonic, passphrase)
                )
                if (validator.isValid) {
                    val privateKey = WalletHandler().getCoin(coin)
                        .getPrivateKey(path!!, mnemonic!!, passphrase!!)
                    validator = WalletHandler().validate(
                        WalletError(
                            WalletHandlerErrorCodes.addressNull,
                            "Could not generate private key.",
                            null
                        ), arrayOf(privateKey)
                    )
                    if (validator.isValid) return result.success(privateKey)
                }
                return result.error(
                    validator.details.errorCode,
                    validator.details.errorMessage,
                    validator.details.errorDetails
                )
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

}

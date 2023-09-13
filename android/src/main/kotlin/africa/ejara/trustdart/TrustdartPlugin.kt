package africa.ejara.trustdart

import africa.ejara.trustdart.utils.ErrorResponse
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
                var validator = WalletHandler().validate<Any?>(
                    WalletError(
                        WalletHandlerErrorCodes.ArgumentsNull,
                        "[strength] and [passphrase] are required.",
                        null
                    ), arrayOf(call.arguments())
                )
                if (validator.isValid) {
                    val wallet = WalletHandler().generateMnemonic(128, call.arguments()!!)
                    validator = WalletHandler().validate<Any?>(
                        WalletError(
                            WalletHandlerErrorCodes.NoWallet,
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
                        WalletHandlerErrorCodes.ArgumentsNull,
                        "[mnemonic] and [passphrase] are required.",
                        null
                    ), arrayOf(mnemonic, passphrase)
                )
                if (validator.isValid) {
                    val wallet = WalletHandler().checkMnemonic(mnemonic!!, passphrase!!)
                    validator = WalletHandler().validate<HDWallet?>(
                        WalletError(
                            WalletHandlerErrorCodes.NoWallet,
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
                        WalletHandlerErrorCodes.ArgumentsNull,
                        ErrorResponse.argumentsNull,
                        null
                    ), arrayOf(path, coin, mnemonic, passphrase)
                )
                if (validator.isValid) {
                    val address = WalletHandler().getCoin(coin)
                        .generateAddress(path!!, mnemonic!!, passphrase!!)
                    validator = WalletHandler().validate(
                        WalletError(
                            WalletHandlerErrorCodes.AddressNull,
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
                        WalletHandlerErrorCodes.ArgumentsNull,
                        "[coin] and [address] are required.",
                        null
                    ), arrayOf(coin, address)
                )
                if (validator.isValid && WalletHandler().getCoin(coin)
                        .validateAddress(address!!)
                ) return result.success(true)
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
                        WalletHandlerErrorCodes.ArgumentsNull,
                        "[path], [coin], [mnemonic], [passphrase] and [txData] are required.",
                        null
                    ), arrayOf(path, coin, mnemonic, txData, passphrase)
                )
                if (validator.isValid) {
                    val txHash = WalletHandler().getCoin(coin)
                        .signTransaction(path!!, txData!!, mnemonic!!, passphrase!!)
                    validator = WalletHandler().validate(
                        WalletError(
                            WalletHandlerErrorCodes.TxHashNull,
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
            "multiSignTransaction" -> {
                val coin: String? = call.argument("coin")
                val path: String? = call.argument("path")
                val txData: Map<String, Any>? = call.argument("txData")
                val privateKeys: ArrayList<String>? = call.argument("privateKeys")
                var validator = WalletHandler().validate(
                    WalletError(
                        WalletHandlerErrorCodes.ArgumentsNull,
                        "[path], [coin], [privateKeys] and [txData] are required.",
                        null
                    ), arrayOf(path, coin, txData, privateKeys)
                )
                if (validator.isValid) {
                    val txHash = WalletHandler().getCoin(coin)
                        .multiSignTransaction(path!!, txData!!, privateKeys!!)
                    validator = WalletHandler().validate(
                        WalletError(
                            WalletHandlerErrorCodes.TxHashNull,
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
            "signDataWithPrivateKey" -> {
                val coin: String? = call.argument("coin")
                val path: String? = call.argument("path")
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")
                val txData: String? = call.argument("txData")
                var validator = WalletHandler().validate(
                    WalletError(
                        WalletHandlerErrorCodes.ArgumentsNull,
                        "[path], [coin], [mnemonic], [passphrase] and [txData] are required.",
                        null
                    ), arrayOf(path, coin, mnemonic, txData, passphrase)
                )
                if (validator.isValid) {
                    val txHash = WalletHandler().getCoin(coin)
                        .signDataWithPrivateKey(path!!, mnemonic!!, passphrase!!, txData!!)
                    validator = WalletHandler().validate(
                        WalletError(
                            WalletHandlerErrorCodes.TxHashNull,
                            "Could not sign data.",
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
                        WalletHandlerErrorCodes.ArgumentsNull,
                        ErrorResponse.argumentsNull,
                        null
                    ), arrayOf(path, coin, mnemonic, passphrase)
                )
                if (validator.isValid) {
                    val publicKey =
                        WalletHandler().getCoin(coin).getPublicKey(path!!, mnemonic!!, passphrase!!)
                    validator = WalletHandler().validate(
                        WalletError(
                            WalletHandlerErrorCodes.AddressNull,
                            ErrorResponse.publicKeyNull,
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
            "getRawPublicKey" -> {
                val path: String? = call.argument("path")
                val coin: String? = call.argument("coin")
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")

                var validator = WalletHandler().validate<Any?>(
                    WalletError(
                        WalletHandlerErrorCodes.ArgumentsNull,
                        ErrorResponse.argumentsNull,
                        null
                    ), arrayOf(path, coin, mnemonic, passphrase)
                )
                if (validator.isValid) {
                    val publicKey =
                        WalletHandler().getCoin(coin)
                            .getRawPublicKey(path!!, mnemonic!!, passphrase!!)
                    if (publicKey != null) {
                        validator = WalletHandler().validate(
                            WalletError(
                                WalletHandlerErrorCodes.AddressNull,
                                ErrorResponse.publicKeyNull,
                                null
                            ), publicKey.toTypedArray()
                            //), arrayOf(publicKey)
                        )
                    }
                    if (validator.isValid) return result.success(publicKey)
                }
                return result.error(
                    validator.details.errorCode,
                    validator.details.errorMessage,
                    validator.details.errorDetails
                )
            }
            "getSeed" -> {
                val path: String? = call.argument("path")
                val coin: String? = call.argument("coin")
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")

                var validator = WalletHandler().validate<Any?>(
                    WalletError(
                        WalletHandlerErrorCodes.ArgumentsNull,
                        ErrorResponse.argumentsNull,
                        null
                    ), arrayOf(path, coin, mnemonic, passphrase)
                )
                if (validator.isValid) {
                    val privateKey = WalletHandler().getCoin(coin)
                        .getSeed(path!!, mnemonic!!, passphrase!!)
                    validator = WalletHandler().validate(
                        WalletError(
                            WalletHandlerErrorCodes.AddressNull,
                            ErrorResponse.privateKeyNull,
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
            "getPrivateKey" -> {
                val path: String? = call.argument("path")
                val coin: String? = call.argument("coin")
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")

                var validator = WalletHandler().validate<Any?>(
                    WalletError(
                        WalletHandlerErrorCodes.ArgumentsNull,
                        ErrorResponse.argumentsNull,
                        null
                    ), arrayOf(path, coin, mnemonic, passphrase)
                )
                if (validator.isValid) {
                    val privateKey = WalletHandler().getCoin(coin)
                        .getPrivateKey(path!!, mnemonic!!, passphrase!!)
                    validator = WalletHandler().validate(
                        WalletError(
                            WalletHandlerErrorCodes.AddressNull,
                            ErrorResponse.privateKeyNull,
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
            "getRawPrivateKey" -> {
                val path: String? = call.argument("path")
                val coin: String? = call.argument("coin")
                val mnemonic: String? = call.argument("mnemonic")
                val passphrase: String? = call.argument("passphrase")

                var validator = WalletHandler().validate<Any?>(
                    WalletError(
                        WalletHandlerErrorCodes.ArgumentsNull,
                        ErrorResponse.argumentsNull,
                        null
                    ), arrayOf(path, coin, mnemonic, passphrase)
                )
                if (validator.isValid) {
                    val privateKey = WalletHandler().getCoin(coin)
                        .getRawPrivateKey(path!!, mnemonic!!, passphrase!!)
                    validator = WalletHandler().validate(
                        WalletError(
                            WalletHandlerErrorCodes.AddressNull,
                            ErrorResponse.privateKeyNull,
                            null
                        ), privateKey!!.toTypedArray()
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

package africa.ejara.trustdart

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


import wallet.core.jni.HDWallet
import wallet.core.jni.CoinType

/** TrustdartPlugin */
class TrustdartPlugin: FlutterPlugin, MethodCallHandler {

  init {
    System.loadLibrary("TrustWalletCore")
  }

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var wallet: HDWallet


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "trustdart")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    println(call.method)
    println(::wallet.isInitialized)
    when(call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "createWallet" -> {
        wallet = HDWallet(128, "")
        result.success(wallet.mnemonic())
      }
      "importWalletFromMnemonic" -> {
        val mnmemonic: String = call.arguments()
        println(mnmemonic)
        wallet = HDWallet(mnmemonic, "")
        result.success(true)
      }
      "generateAddressForCoin" -> {
        val path: String? = call.argument("path")
        val coin: String? = call.argument("coin")
        print("$coin $path")
        if (path != null && coin != null) {
          val address: String? = generateAddressForCoin(path, coin)
          if (address == null) result.error("address_null", "failed to generate address", null) else result.success(address)
        } else {
          result.error("arguments_null", "$path and $coin cannot be null", null)
        }
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun generateAddressForCoin(path: String, coin: String): String? {
    val key = wallet.getKey(path)   // m/44'/60'/1'/0/0
    return when(coin) {
      "BTC" -> {
        CoinType.BITCOIN.deriveAddress(key)
      }
      "ETH" -> {
        CoinType.ETHEREUM.deriveAddress(key)
      }
      "XTZ" -> {
        CoinType.TEZOS.deriveAddress(key)
      }
      else -> null
    }
  }
}

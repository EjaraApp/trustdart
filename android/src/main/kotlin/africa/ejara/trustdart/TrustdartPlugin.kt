package africa.ejara.trustdart

import androidx.annotation.NonNull
import org.json.JSONObject

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


import wallet.core.jni.HDWallet
import wallet.core.jni.CoinType
import wallet.core.jni.BitcoinAddress
import wallet.core.java.AnySigner

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
        wallet = HDWallet(mnmemonic, "")
        result.success(true)
      }
      "generateAddressForCoin" -> {
        if (!::wallet.isInitialized) return result.error("empty_wallet", "wallet not initialized", null)
        val path: String? = call.argument("path")
        val coin: String? = call.argument("coin")
        if (path != null && coin != null) {
          val address: Map<String, String?>? = generateAddressForCoin(path, coin)
          if (address == null) result.error("address_null", "failed to generate address", null) else result.success(address)
        } else {
          result.error("arguments_null", "[path] and [coin] cannot be null", null)
        }
      }
      "validateAddressForCoin" -> {
        val address: String? = call.argument("address")
        val coin: String? = call.argument("coin")
        if (address != null && coin != null) {
          val isValid: Boolean = validateAddressForCoin(coin, address)
          result.success(isValid)
        } else {
          result.error("arguments_null", "$address and $coin cannot be null", null)
        }
      }
      "buildAndSignTransaction" -> {
        val coin: String? = call.argument("coin")
        val path: String? = call.argument("path")
        val txData: Map<String, String>? = call.argument("txData")
        if (txData != null && coin != null && path != null) {
          val txHash: String? = buildAndSignTransaction(coin, path, txData)
          if (txHash == null) result.error("txhash_null", "failed to buid and sign transaction", null) else result.success(txHash)
        } else {
          result.error("arguments_null", "[txData], [coin] and [path] cannot be null", null)
        }
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun generateAddressForCoin(path: String, coin: String): Map<String, String?>? {
    return when(coin) {
      "BTC" -> {
        val privateKey = wallet.getKey(CoinType.BITCOIN, path)
        val publicKey = privateKey.getPublicKeySecp256k1(true)
        val address = BitcoinAddress(publicKey, CoinType.BITCOIN.p2pkhPrefix())
        mapOf("legacy" to address.description(), "segwit" to CoinType.BITCOIN.deriveAddress(privateKey))
      }
      "ETH" -> {
        val privateKey = wallet.getKey(CoinType.ETHEREUM, path)
        mapOf("legacy" to CoinType.ETHEREUM.deriveAddress(privateKey))
      }
      "XTZ" -> {
        val privateKey = wallet.getKey(CoinType.TEZOS, path)
        mapOf("legacy" to CoinType.TEZOS.deriveAddress(privateKey))
      }
      else -> null
    }
  }

  private fun validateAddressForCoin(coin: String, address: String): Boolean {
    return when(coin) {
      "BTC" -> {
        CoinType.BITCOIN.validate(address)
      }
      "ETH" -> {
        CoinType.ETHEREUM.validate(address)
      }
      "XTZ" -> {
        CoinType.TEZOS.validate(address)
      }
      else -> false
    }
  }

  private fun buildAndSignTransaction(coin: String, path: String, txData: Map<String, String>): String? {
    return when(coin) {
      "XTZ" -> {
        buildAndSignTezosTransaction(path, txData)
      }
      "ETH" -> {
        buildAndSignEthereumTransaction(path, txData)
      }
      "BTC" -> {
        buildAndSignBitcoinTransaction(path, txData)
      }
      else -> null
    }
  }

  private fun buildAndSignTezosTransaction(path: String, txData: Map<String, String>): String? {
    val privateKey = wallet.getKey(CoinType.TEZOS, path)
    val opJson =  JSONObject(txData).toString();
    val result = AnySigner.signJSON(opJson, privateKey.data(), CoinType.TEZOS.value())
    return result
  }

  private fun buildAndSignEthereumTransaction(path: String, txData: Map<String, String>): String? {
    val privateKey = wallet.getKey(CoinType.ETHEREUM, path)
    val opJson =  JSONObject(txData).toString();
    val result = AnySigner.signJSON(opJson, privateKey.data(), CoinType.ETHEREUM.value())
    return result
  }

  private fun buildAndSignBitcoinTransaction(path: String, txData: Map<String, String>): String? {
    val privateKey = wallet.getKey(CoinType.BITCOIN, path)
    return null;
  }
}

package africa.ejara.trustdart

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


import wallet.core.jni.HDWallet

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
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

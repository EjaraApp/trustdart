package africa.ejara.trustdart

import africa.ejara.trustdart.interfaces.CoinInterface
import android.util.Base64
import org.json.JSONObject
import wallet.core.java.AnySigner
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet

open class Coin(nameOfCoin: String, typeOfCoin: CoinType) : CoinInterface {

    private var name: String? = null
    var coinType: CoinType? = null

    init {
        name = nameOfCoin
        coinType = typeOfCoin
    }

    override fun generateAddress(
        path: String,
        mnemonic: String,
        passphrase: String
    ): Map<String, String?>? {
        val wallet = HDWallet(mnemonic, passphrase)
        return mapOf("legacy" to coinType!!.deriveAddress(wallet.getKey(coinType, path)))
    }


    override fun getPrivateKey(path: String, mnemonic: String, passphrase: String): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val privateKey: String? =
            Base64.encodeToString(wallet.getKey(coinType, path).data(), Base64.DEFAULT)
        return if (privateKey == null) null else privateKey
    }

    override fun getPublicKey(path: String, mnemonic: String, passphrase: String): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val publicKey: String? = Base64.encodeToString(
            wallet.getKey(coinType, path)
                .getPublicKeySecp256k1(true).data(),
            Base64.DEFAULT
        )
        return if (publicKey == null) null else publicKey
    }
    
    override fun getPublicKeyRaw(path: String, mnemonic: String, passphrase: String): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val publicKey: String? = String(wallet.getKey(coinType, path)
            .getPublicKeySecp256k1(true).data(), Charsets.UTF_8)
        return if (publicKey == null) null else publicKey
    }

    override fun validateAddress(address: String): Boolean {
        return coinType!!.validate(address)
    }

    override fun signTransaction(
        path: String,
        txData: Map<String, Any>,
        mnemonic: String,
        passphrase: String
    ): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val privateKey = wallet.getKey(coinType, path)
        val opJson = JSONObject(txData).toString();
        return AnySigner.signJSON(opJson, privateKey.data(), coinType!!.value())
    }

}
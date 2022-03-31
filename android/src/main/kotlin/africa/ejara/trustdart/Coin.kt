package africa.ejara.trustdart

import africa.ejara.trustdart.interfaces.CoinInterface
import android.annotation.SuppressLint
import org.json.JSONObject
import wallet.core.java.AnySigner
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet
import java.util.*

open class Coin(nameOfCoin: String, typeOfCoin: CoinType) : CoinInterface {

    private var name: String? = null
    var coinType: CoinType? = null

    init {
        name = nameOfCoin
        coinType = typeOfCoin
    }

    override fun generateAddress(
        path: String?,
        mnemonic: String?,
        passphrase: String?
    ): Map<String, String?>? {
        if (path != null && mnemonic != null && passphrase != null) {
            val wallet = HDWallet(mnemonic, passphrase)

            if (wallet != null) {
                val address: Map<String, String?>? = generateAddress(wallet, path)
                return if (address == null) null else address
            }
        }
        return null
    }


    override fun generateAddress(wallet: HDWallet, path: String): Map<String, String>? {
        return mapOf("legacy" to coinType!!.deriveAddress(wallet.getKey(coinType, path)))
    }

    @SuppressLint("NewApi")
    override fun getPrivateKey(path: String?, mnemonic: String?, passphrase: String?): String? {
        if (path != null && mnemonic != null && passphrase != null) {
            val wallet = HDWallet(mnemonic, passphrase)

            if (wallet != null) {
                val privateKey: String? =
                    Base64.getEncoder().encodeToString(wallet.getKey(coinType, path).data())
                return if (privateKey == null) null else privateKey
            }
        }
        return null
    }

    @SuppressLint("NewApi")
    override fun getPublicKey(path: String?, mnemonic: String?, passphrase: String?): String? {
        if (path != null && mnemonic != null && passphrase != null) {
            val wallet = HDWallet(mnemonic, passphrase)

            if (wallet != null) {
                val publicKey: String? = Base64.getEncoder().encodeToString(
                    wallet.getKey(coinType, path)
                        .getPublicKeySecp256k1(true).data()
                )
                return if (publicKey == null) null else publicKey
            }
        }
        return null
    }

    override fun validateAddress(address: String?): Boolean? {
        if (address != null) {
            return coinType!!.validate(address)
        }
        return null
    }

    override fun signTransaction(
        path: String?,
        txData: Map<String, Any>?,
        mnemonic: String?,
        passphrase: String?
    ): String? {
        if (txData != null && path != null && mnemonic != null) {
            val wallet = HDWallet(mnemonic, passphrase)

            if (wallet != null) {
                val txHash: String? = signTransaction(wallet, path, txData)
                return if (txHash == null) null else txHash
            }
        }
        return null
    }

    override fun signTransaction(
        wallet: HDWallet,
        path: String,
        txData: Map<String, Any>
    ): String? {
        print("CoinType" + coinType)
        val privateKey = wallet.getKey(coinType, path)
        val opJson = JSONObject(txData).toString();
        return AnySigner.signJSON(opJson, privateKey.data(), coinType!!.value())
    }

}
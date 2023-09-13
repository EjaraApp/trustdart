package africa.ejara.trustdart

import africa.ejara.trustdart.interfaces.CoinInterface
import africa.ejara.trustdart.utils.base64String
import africa.ejara.trustdart.utils.toHex
import africa.ejara.trustdart.utils.toHexByteArray
import com.google.protobuf.ByteString
import org.json.JSONObject
import wallet.core.java.AnySigner
import wallet.core.jni.CoinType
import wallet.core.jni.Curve
import wallet.core.jni.HDWallet

open class Coin(nameOfCoin: String, typeOfCoin: CoinType) : CoinInterface {

    var name: String? = null
    var coinType: CoinType? = null

    init {
        name = nameOfCoin
        coinType = typeOfCoin
    }

    override fun generateAddress(
        path: String,
        mnemonic: String,
        passphrase: String
    ): Map<String, String>? {
        val wallet = HDWallet(mnemonic, passphrase)
        return mapOf("legacy" to coinType!!.deriveAddress(wallet.getKey(coinType, path)))
    }

    override fun getPrivateKey(path: String, mnemonic: String, passphrase: String): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType, path).data().base64String()
    }

    override fun getSeed(path: String, mnemonic: String, passphrase: String): ByteArray? {
        val data = HDWallet(mnemonic, passphrase).seed()
        print("Seed Data: $data")
        return data
    }

    override fun getRawPrivateKey(path: String, mnemonic: String, passphrase: String): ByteArray? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType, path).data()
    }

    override fun getPublicKey(path: String, mnemonic: String, passphrase: String): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType, path).getPublicKeySecp256k1(true).data().base64String()
    }

    override fun getRawPublicKey(path: String, mnemonic: String, passphrase: String): ByteArray? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType, path).getPublicKeySecp256k1(true).data()
    }

    override fun validateAddress(address: String): Boolean {
        return coinType!!.validate(address)
    }

    override fun signDataWithPrivateKey(
        path: String,
        mnemonic: String,
        passphrase: String,
        txData: String
    ): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val privateKey = wallet.getKey(coinType, path)
        return privateKey.sign(txData.toHexByteArray(), coinType!!.curve()).toHex()
    }

    override fun signTransaction(
        path: String,
        txData: Map<String, Any>,
        mnemonic: String,
        passphrase: String
    ): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val privateKey = wallet.getKey(coinType, path)
        val opJson = JSONObject(txData).toString()
        return AnySigner.signJSON(opJson, privateKey.data(), coinType!!.value())
    }

    override fun multiSignTransaction(
        path: String,
        txData: Map<String, Any>,
        privateKeys: ArrayList<String>
    ): String? {
        val opJson = JSONObject(txData).toString()
        val signatures = mutableListOf<String>()

        for (privateKey in privateKeys) {
            val signature = AnySigner.signJSON(opJson, privateKey.toByteArray(), coinType!!.value())
            signatures.add(signature)
        }
        return signatures.joinToString(",")
    }

}

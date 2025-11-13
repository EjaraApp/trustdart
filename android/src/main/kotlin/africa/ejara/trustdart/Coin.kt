package africa.ejara.trustdart

import africa.ejara.trustdart.interfaces.CoinInterface
import africa.ejara.trustdart.utils.base64String
import africa.ejara.trustdart.utils.toHex
import africa.ejara.trustdart.utils.toHexByteArray
import org.json.JSONObject
import wallet.core.java.AnySigner
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet

open class Coin<T1, T2>(nameOfCoin: T1, typeOfCoin: T2) : CoinInterface {

    var name: T1? = null
    var coinType: T2? = null

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
        return mapOf("legacy" to (coinType!! as CoinType).deriveAddress(wallet.getKey(coinType as CoinType?, path)))
    }

    override fun getPrivateKey(path: String, mnemonic: String, passphrase: String): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType as CoinType?, path).data().base64String()
    }

    override fun getSeed(path: String, mnemonic: String, passphrase: String): ByteArray? {
        val data = HDWallet(mnemonic, passphrase).seed()
        return data
    }

    override fun getRawPrivateKey(path: String, mnemonic: String, passphrase: String): ByteArray? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType as CoinType?, path).data()
    } 

    override fun getPublicKey(path: String, mnemonic: String, passphrase: String): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType as CoinType?, path).getPublicKeySecp256k1(true).data().base64String()
    }
 
    override fun getRawPublicKey(path: String, mnemonic: String, passphrase: String): ByteArray? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType as CoinType?, path).getPublicKeySecp256k1(true).data()
    }

    override fun validateAddress(address: String): Boolean {
        return (coinType!! as CoinType).validate(address)
    }

    override fun signDataWithPrivateKey(
        path: String,
        mnemonic: String,
        passphrase: String,
        txData: String
    ): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val privateKey = wallet.getKey(coinType as CoinType?, path)
        return privateKey.sign(txData.toHexByteArray(), (coinType!! as CoinType).curve()).toHex()
    }

    override fun signTransaction(
        path: String,
        txData: Map<String, Any>,
        mnemonic: String,
        passphrase: String
    ): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val privateKey = wallet.getKey(coinType as CoinType?, path)
        val opJson = JSONObject(txData).toString()
        return AnySigner.signJSON(opJson, privateKey.data(), (coinType!! as CoinType).value())
    }

    override fun multiSignTransaction(
        txData: Map<String, Any>,
        privateKeys: ArrayList<String>
    ): String? {
        val opJson = JSONObject(txData).toString()
        val signatures = mutableListOf<String>()

        for (privateKey in privateKeys) {
            val signature = AnySigner.signJSON(opJson, privateKey.toByteArray(), (coinType!! as CoinType).value())
            signatures.add(signature)
        }
        return signatures.joinToString(",")
    }

}

import africa.ejara.trustdart.Coin
import africa.ejara.trustdart.utils.base64String
import africa.ejara.trustdart.utils.toHex
import africa.ejara.trustdart.utils.toHexBytes
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet
import wallet.core.jni.Hash

class XTZ : Coin("XTZ", CoinType.TEZOS) {

    override fun getPublicKey(path: String, mnemonic: String, passphrase: String): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType, path).publicKeyEd25519.data().base64String()
    }

    override fun getRawPublicKey(path: String, mnemonic: String, passphrase: String): ByteArray? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType, path)
            .publicKeyEd25519.data()
    }

    override fun signDataWithPrivateKey(
        path: String,
        mnemonic: String,
        passphrase: String,
        txData: String
    ): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val privateKey = wallet.getKey(coinType, path)
        val hash: ByteArray? = Hash.blake2b(txData.toHexBytes(), 32)
        return privateKey.sign(hash, coinType!!.curve()).toHex()
    }

}
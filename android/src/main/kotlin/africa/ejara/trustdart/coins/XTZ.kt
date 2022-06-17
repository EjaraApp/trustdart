import africa.ejara.trustdart.Coin
import android.util.Base64
import wallet.core.jni.CoinType
import wallet.core.jni.Curve
import wallet.core.jni.HDWallet
import wallet.core.jni.Purpose

class XTZ : Coin("XTZ", CoinType.TEZOS) {

    override fun getPublicKey(path: String, mnemonic: String, passphrase: String): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val publicKey: String? = Base64.encodeToString(
            wallet.getKey(coinType, path)
                .publicKeyEd25519.data(),
            Base64.DEFAULT
        )
        return if (publicKey == null) null else publicKey
    }

    override fun getPublicKeyRaw(path: String, mnemonic: String, passphrase: String): ByteArray? {
        val wallet = HDWallet(mnemonic, passphrase)
        val publicKey: ByteArray? = wallet.getKey(coinType, path)
            .publicKeyEd25519.data()
        return if (publicKey == null) null else publicKey
    }

    override fun getPrivateKeyRaw(path: String, mnemonic: String, passphrase: String): ByteArray? {
        val wallet = HDWallet(mnemonic, passphrase)
        val privateKey: ByteArray? = wallet.getKey(coinType, path).data()
        return if (privateKey == null) null else privateKey
    }

    override fun getSeed(path: String, mnemonic: String, passphrase: String): ByteArray? {
        val wallet = HDWallet(mnemonic, passphrase)
        val walletSeed: ByteArray? = wallet.seed()
        return if (walletSeed == null) null else walletSeed
    }
}
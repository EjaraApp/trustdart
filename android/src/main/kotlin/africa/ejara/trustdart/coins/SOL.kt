import africa.ejara.trustdart.Coin
import africa.ejara.trustdart.utils.base64String
import africa.ejara.trustdart.utils.toHex
import android.util.Base64
import wallet.core.jni.CoinType
import wallet.core.jni.Curve
import wallet.core.jni.HDWallet


class SOL : Coin("SOL", CoinType.SOLANA) {
    override fun getPublicKey(path: String, mnemonic: String, passphrase: String): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType, path).publicKeyEd25519.data().base64String()
    }

    override fun getRawPublicKey(path: String, mnemonic: String, passphrase: String): ByteArray? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType, path).publicKeyEd25519.data()
    }
}
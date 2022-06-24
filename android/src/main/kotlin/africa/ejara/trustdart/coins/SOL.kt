import africa.ejara.trustdart.Coin
import android.util.Base64
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet


class SOL : Coin("SOL", CoinType.SOLANA) {
    override fun getPublicKey(path: String, mnemonic: String, passphrase: String): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        return Base64.encodeToString(
            wallet.getKey(coinType, path)
                .publicKeyEd25519.data(), Base64.DEFAULT
        )
    }

    override fun getRawPublicKey(path: String, mnemonic: String, passphrase: String): ByteArray? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType, path)
            .publicKeyEd25519.data()
    }
}
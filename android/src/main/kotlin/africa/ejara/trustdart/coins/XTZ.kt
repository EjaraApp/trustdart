import africa.ejara.trustdart.Coin
import android.annotation.SuppressLint
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet
import java.util.*

class XTZ : Coin("XTZ", CoinType.TEZOS) {

    @SuppressLint("NewApi")
    override fun getPublicKey(path: String?, mnemonic: String?, passphrase: String?): String? {
        if (path != null && mnemonic != null && passphrase != null) {
            val wallet = HDWallet(mnemonic, passphrase)

            if (wallet != null) {
                val publicKey: String? = Base64.getEncoder().encodeToString(
                    wallet.getKey(coinType, path)
                        .publicKeyEd25519.data()
                )
                return if (publicKey == null) null else publicKey
            }
        }
        return null
    }
}
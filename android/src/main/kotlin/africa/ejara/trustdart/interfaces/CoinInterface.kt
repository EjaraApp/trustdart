package africa.ejara.trustdart.interfaces
 
import com.google.protobuf.ByteString

interface CoinInterface {
    fun generateAddress(path: String, mnemonic: String, passphrase: String): Map<String, String>?
    fun getSeed(path: String, mnemonic: String, passphrase: String): ByteArray?
    fun getPrivateKey(path: String, mnemonic: String, passphrase: String): String?
    fun getRawPrivateKey(path: String, mnemonic: String, passphrase: String): ByteArray?
    fun getPublicKey(path: String, mnemonic: String, passphrase: String): String?
    fun getRawPublicKey(path: String, mnemonic: String, passphrase: String): ByteArray?
    fun validateAddress(address: String): Boolean
    fun signDataWithPrivateKey(path: String, mnemonic: String, passphrase: String, txData: String): String?
    fun signTransaction(path: String, txData: Map<String, Any>, mnemonic: String, passphrase: String): String?
   fun multiSignTransaction(
       txData: Map<String, Any>,
       privateKeys: ArrayList<String>
   ): String?
}
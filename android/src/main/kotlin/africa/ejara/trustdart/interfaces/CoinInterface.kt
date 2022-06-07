package africa.ejara.trustdart.interfaces

interface CoinInterface {
    fun generateAddress(path: String, mnemonic: String, passphrase: String): Map<String, String?>?

    fun getPrivateKey(path: String, mnemonic: String, passphrase: String): String?
    fun getPublicKey(path: String, mnemonic: String, passphrase: String): String?
    fun getPublicKeyRaw(path: String, mnemonic: String, passphrase: String): String?
    fun validateAddress(address: String): Boolean
    fun signTransaction(
            path: String,
            txData: Map<String, Any>,
            mnemonic: String,
            passphrase: String
    ): String?
}

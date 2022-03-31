package africa.ejara.trustdart.interfaces

import wallet.core.jni.HDWallet

interface CoinInterface {
    fun generateAddress(
        path: String?,
        mnemonic: String?,
        passphrase: String?
    ): Map<String, String?>?

    fun generateAddress(wallet: HDWallet, path: String): Map<String, String?>?
    fun getPrivateKey(path: String?, mnemonic: String?, passphrase: String?): String?
    fun getPublicKey(path: String?, mnemonic: String?, passphrase: String?): String?
    fun validateAddress(address: String?): Boolean?
    fun signTransaction(
        path: String?,
        txData: Map<String, Any>?,
        mnemonic: String?,
        passphrase: String?
    ): String?

    fun signTransaction(wallet: HDWallet, path: String, txData: Map<String, Any>): String?
}
package africa.ejara.trustdart

import BTC
import ETH
import SOL
import TRX
import XTZ
import wallet.core.jni.HDWallet

class WalletHandler {
    private val coins: MutableMap<String, Coin> = HashMap()

    init {
        coins["BTC"] = BTC()
        coins["ETH"] = ETH()
        coins["XTZ"] = XTZ()
        coins["TRX"] = TRX()
        coins["SOL"] = SOL()
    }

    fun getCoin(coin: String?): Coin {
        return coins[coin]!!
    }

    fun generateMnemonic(passphrase: String): String? {
        return HDWallet(128, passphrase).mnemonic()
    }

    fun checkMnemonic(mnemonic: String?, passphrase: String?): Boolean {
        if (mnemonic != null && passphrase != null) {
            val wallet = HDWallet(mnemonic, passphrase)
            if (wallet != null) return true
        }
        return false
    }

}
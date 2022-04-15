package africa.ejara.trustdart

import BTC
import ETH
import NEAR
import SOL
import TERRA
import TRX
import XTZ
import africa.ejara.trustdart.utils.WalletError
import africa.ejara.trustdart.utils.WalletValidateResponse
import wallet.core.jni.HDWallet

class WalletHandler {
    private val coins: MutableMap<String, Coin> = HashMap()

    init {
        coins["BTC"] = BTC()
        coins["ETH"] = ETH()
        coins["XTZ"] = XTZ()
        coins["TRX"] = TRX()
        coins["SOL"] = SOL()
        coins["NEAR"] = NEAR()
        coins["TERRA"] = TERRA()
    }

    fun getCoin(coin: String?): Coin {
        return coins[coin]!!
    }

    fun generateMnemonic(strength: Int, passphrase: String): String? {
        return HDWallet(strength, passphrase).mnemonic()
    }

    fun checkMnemonic(mnemonic: String, passphrase: String): HDWallet {
        return HDWallet(mnemonic, passphrase)
    }

    fun <T> validate(walletError: WalletError, data: Array<T>): WalletValidateResponse {
        var isValid = true
        for (_data in data) {
            if (_data == null) {
                isValid = false
            }
        }
        return WalletValidateResponse(isValid, walletError)
    }
}

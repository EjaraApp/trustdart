package africa.ejara.trustdart

import BTC
import ETH
import NEAR
import SOL
import TRX
import XTZ
import XLM
import BNB
import DOGE
import MATIC
import ADA

import africa.ejara.trustdart.utils.WalletError
import africa.ejara.trustdart.utils.WalletValidateResponse
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet

class WalletHandler {

    companion object {
        val coins = mapOf(
            "BTC"   to BTC(),
            "ETH"   to ETH(),
            "XTZ"   to XTZ(),
            "TRX"   to TRX(),
            "SOL"   to SOL(),
            "NEAR"  to NEAR(),
            "XLM"   to XLM(),
            "BNB"   to BNB(),
            "BSC"   to ETH(),
            "DOGE"  to DOGE(),
            "MATIC" to ETH(),
            "ADA"   to ADA(),
        )
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

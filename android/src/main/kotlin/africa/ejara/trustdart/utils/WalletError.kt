package africa.ejara.trustdart.utils


class WalletError(
    errorCode: WalletHandlerErrorCodes,
    val errorMessage: String?,
    val errorDetails: Any?
) {
    val errorCode: String = errorCode.value
}

data class WalletValidateResponse(val isValid: Boolean, val details: WalletError)

enum class WalletHandlerErrorCodes(val value: String) {
    NoWallet("no_wallet"),
    AddressNull("address_null"),
    ArgumentsNull("arguments_null"),
    TxHashNull("txhash_null")
}

class ErrorResponse {
    companion object {
        const val argumentsNull = "[path], [coin], [mnemonic] and [passphrase] are required."
        const val privateKeyNull = "Could not generate private key."
        const val publicKeyNull = "Could not generate public key."
    }
}

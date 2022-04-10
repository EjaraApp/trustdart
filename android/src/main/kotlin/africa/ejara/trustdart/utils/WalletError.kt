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
    noWallet("no_wallet"),
    addressNull("address_null"),
    argumentsNull("arguments_null"),
    txHashNull("txhash_null")
}
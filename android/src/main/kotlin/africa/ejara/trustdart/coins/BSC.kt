import africa.ejara.trustdart.Coin
import com.google.protobuf.ByteString
import wallet.core.java.AnySigner
import africa.ejara.trustdart.Numeric
import africa.ejara.trustdart.utils.toHexByteArray
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet
import wallet.core.jni.proto.Ethereum.SigningOutput
import wallet.core.jni.proto.Ethereum


class BSC : Coin("BSC", CoinType.SMARTCHAIN) {

    override fun signTransaction(
        path: String,
        txData: Map<String, Any>,
        mnemonic: String,
        passphrase: String
    ): String? {
        val signingInput = Ethereum.SigningInput.newBuilder()
        val wallet = HDWallet(mnemonic, passphrase)
        val private_key = wallet.getKey(coinType, path)
        signingInput.apply {
            privateKey = ByteString.copyFrom(private_key.data())
            toAddress = txData["toAddress"] as String
            chainId = ByteString.copyFrom((txData["chainID"] as String).toHexByteArray())
            nonce = ByteString.copyFrom((txData["nonce"] as String).toHexByteArray())
            gasPrice = ByteString.copyFrom((txData["gasPrice"] as String).toHexByteArray())
            gasLimit = ByteString.copyFrom((txData["gasLimit"] as String).toHexByteArray())
            transaction = Ethereum.Transaction.newBuilder().apply {
                transfer = Ethereum.Transaction.Transfer.newBuilder().apply {
                    amount = ByteString.copyFrom((txData["amount"] as String).toHexByteArray())
                }.build()
            }.build()
        }

        val sign = AnySigner.sign(signingInput.build(), coinType, SigningOutput.parser())
        return "0x" + Numeric.toHexString(sign.encoded.toByteArray())

    }
}


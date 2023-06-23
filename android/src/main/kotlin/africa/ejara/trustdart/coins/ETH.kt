import africa.ejara.trustdart.Coin
import com.google.protobuf.ByteString
import wallet.core.java.AnySigner
import africa.ejara.trustdart.Numeric
import africa.ejara.trustdart.utils.toHexByteArray
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet
import wallet.core.jni.proto.Ethereum.SigningOutput
import wallet.core.jni.proto.Ethereum

open class ETH: Coin("ETH", CoinType.ETHEREUM)  {

    override fun signTransaction(
        path: String,
        txData: Map<String, Any>,
        mnemonic: String,
        passphrase: String
    ): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val cmd: String? = txData["cmd"] as? String
        val signingInput = Ethereum.SigningInput.newBuilder()

        signingInput.apply {
            privateKey = ByteString.copyFrom(wallet.getKey(coinType, path).data())
            chainId = ByteString.copyFrom((txData["chainID"] as String).toHexByteArray())
            nonce = ByteString.copyFrom((txData["nonce"] as String).toHexByteArray())
            gasPrice = ByteString.copyFrom((txData["gasPrice"] as String).toHexByteArray())
            gasLimit = ByteString.copyFrom((txData["gasLimit"] as String).toHexByteArray())
        }
        when (cmd) {
            "ERC20" -> {

                var transaction = Ethereum.Transaction.newBuilder().apply {
                    erc20Transfer = Ethereum.Transaction.ERC20Transfer.newBuilder().apply {
                        to = txData["toAddress"] as String
                        amount = ByteString.copyFrom((txData["amount"] as String).toHexByteArray())
                    }.build()
                }.build()
                signingInput.setToAddress(txData["contractAddress"] as String)
                signingInput.setTransaction(transaction)
                
            }
            else -> {
                var transaction = Ethereum.Transaction.newBuilder().apply {
                    transfer = Ethereum.Transaction.Transfer.newBuilder().apply {
                        amount = ByteString.copyFrom((txData["amount"] as String).toHexByteArray())
                    }.build()
                }.build()

                signingInput.setToAddress(txData["toAddress"] as String)
                signingInput.setTransaction(transaction)
            }
        }
        val sign = AnySigner.sign(signingInput.build(), coinType, SigningOutput.parser())
        return Numeric.toHexString(sign.encoded.toByteArray())

    }

}
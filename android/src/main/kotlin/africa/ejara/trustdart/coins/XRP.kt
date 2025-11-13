import africa.ejara.trustdart.Coin
import com.google.protobuf.ByteString
import wallet.core.java.AnySigner
import africa.ejara.trustdart.Numeric
import africa.ejara.trustdart.utils.toInt
import africa.ejara.trustdart.utils.toLong
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet
import wallet.core.jni.proto.Ethereum.SigningOutput
import wallet.core.jni.proto.Ripple

class XRP: Coin<String, CoinType>("XRP", CoinType.XRP)  {

    override fun signTransaction(
        path: String,
        txData: Map<String, Any>,
        mnemonic: String,
        passphrase: String
    ): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val signingInput = Ripple.SigningInput.newBuilder()
        val operation = Ripple.OperationPayment.newBuilder()

        operation.apply {
            amount = txData["amount"]!!.toLong()
            destination = txData["receiverAddress"] as String
            if (txData["memo"] != null) {
                destinationTag = txData["memo"]!!.toLong()
            }
        }

        signingInput.apply {
            account = txData["senderAddress" ] as String
            fee = txData["fee"]!!.toLong()
            sequence = txData["sequence"]!!.toInt()
            lastLedgerSequence = txData["lastLedgerSequence"]!!.toInt()
            privateKey = ByteString.copyFrom(wallet.getKey(coinType, path).data())
            opPayment = operation.build()
        }

        val sign = AnySigner.sign(signingInput.build(), coinType, SigningOutput.parser())
        return Numeric.toHexString(sign.encoded.toByteArray())

    }

}
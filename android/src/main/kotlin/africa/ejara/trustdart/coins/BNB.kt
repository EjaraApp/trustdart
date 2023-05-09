import africa.ejara.trustdart.Coin
import com.google.protobuf.ByteString
import wallet.core.jni.*
import wallet.core.jni.CoinType
import wallet.core.java.AnySigner
import wallet.core.jni.proto.Binance
import africa.ejara.trustdart.Numeric
import africa.ejara.trustdart.utils.toLong


class BNB : Coin("BNB", CoinType.BINANCE) {

    override fun signTransaction(
        path: String,
        txData: Map<String, Any>,
        mnemonic: String,
        passphrase: String
    ): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val privateKey = wallet.getKey(coinType, path)
        val publicKey = txData["fromAddress"] as String
        val signingInput = Binance.SigningInput.newBuilder()
        signingInput.chainId = txData["chainID"] as String
        signingInput.accountNumber = txData["accountNumber"]!!.toLong()
        signingInput.sequence = txData["sequence"]!!.toLong()
        signingInput.source = txData["source"]!!.toLong()
        if (txData["memo"] != null) {
            signingInput.memo = txData["memo"] as String
        }
        signingInput.privateKey = ByteString.copyFrom(privateKey.data())

        val token = Binance.SendOrder.Token.newBuilder()
        token.denom = name
        token.amount = txData["amount"]!!.toLong()

        val input = Binance.SendOrder.Input.newBuilder()
        input.address = ByteString.copyFrom(AnyAddress(publicKey, coinType).data())
        input.addAllCoins(listOf(token.build()))

        val output = Binance.SendOrder.Output.newBuilder()
        output.address =
            ByteString.copyFrom(AnyAddress(txData["toAddress"] as String, coinType).data())
        output.addAllCoins(listOf(token.build()))

        val sendOrder = Binance.SendOrder.newBuilder()
        sendOrder.addAllInputs(listOf(input.build()))
        sendOrder.addAllOutputs(listOf(output.build()))

        signingInput.sendOrder = sendOrder.build()

        val sign: Binance.SigningOutput =
            AnySigner.sign(signingInput.build(), coinType, Binance.SigningOutput.parser())
        return Numeric.toHexString(sign.encoded.toByteArray())
    }

}

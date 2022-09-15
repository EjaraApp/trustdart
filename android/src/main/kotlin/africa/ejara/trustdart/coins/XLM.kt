package africa.ejara.trustdart.coins

import com.google.protobuf.ByteString
import wallet.core.java.AnySigner
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet
import africa.ejara.trustdart.Coin
import africa.ejara.trustdart.Numeric
import africa.ejara.trustdart.utils.base64String
import wallet.core.jni.proto.Stellar
import wallet.core.jni.proto.Stellar.SigningOutput
import wallet.core.jni.StellarPassphrase


class XLM : Coin("XLM", CoinType.STELLAR) {

    override fun getPublicKey(path: String, mnemonic: String, passphrase: String): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType, path).publicKeyEd25519.data().base64String()
    }

    override fun signTransaction(
        path: String,
        txData: Map<String, Any>,
        mnemonic: String,
        pass_phrase: String
    ): String? {
        val wallet = HDWallet(mnemonic, pass_phrase)
        val secretKey = wallet.getKey(coinType, path)

        val operation = Stellar.OperationPayment.newBuilder()
        operation.apply {
            destination = txData["toAddress"] as String
            amount = (txData["amount"] as Int).toLong()
        }
        val signingInput = Stellar.SigningInput.newBuilder()
        signingInput.apply {
            account = txData["ownerAddress"] as String
            fee = (txData["fee"] as Int).toLong()
            sequence = (txData["sequence"] as Int).toLong()
            passphrase = StellarPassphrase.STELLAR.toString()
            opPayment = operation.build()
            privateKey = ByteString.copyFrom(secretKey.data())
        }

        val output = AnySigner.sign(signingInput.build(), CoinType.STELLAR, SigningOutput.parser())
        return Numeric.toHexString(output.signature.toByteArray())
    }

}
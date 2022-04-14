import android.util.Base64
import com.google.protobuf.ByteString
import wallet.core.java.AnySigner
import wallet.core.jni.CoinType
import wallet.core.jni.proto.NEAR
import wallet.core.jni.proto.NEAR.SigningOutput
import wallet.core.jni.Base58
import wallet.core.jni.HDWallet
import africa.ejara.trustdart.Coin
import africa.ejara.trustdart.Numeric

class NEAR : Coin("NEAR", CoinType.NEAR) {

    override fun getPublicKey(path: String, mnemonic: String, passphrase: String): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val publicKey: String? = Base64.encodeToString(
            wallet.getKey(coinType, path)
                .publicKeyEd25519.data(),
            Base64.DEFAULT
        )
        return if (publicKey == null) null else publicKey
    }

    override fun signTransaction(
            path: String,
            txData: Map<String, Any>,
            mnemonic: String,
            passphrase: String
    ): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val secretKey = wallet.getKey(coinType, path)
        val transferAction = NEAR.Transfer.newBuilder().apply {
            deposit = ByteString.copyFrom(Numeric.hexStringToByteArray((txData["amount"] as String)))
        }.build()
        val signingInput = NEAR.SigningInput.newBuilder().apply {
            signerId = txData["signerID"] as String
            nonce = (txData["nonce"] as Int).toLong()
            receiverId = txData["receiverID"] as String
            addActionsBuilder().apply {
                transfer = transferAction
            }
            blockHash = ByteString.copyFrom(Base58.decodeNoCheck(txData["blockHash"] as String))
            privateKey = ByteString.copyFrom(secretKey.data())
        }.build()

        val output = AnySigner.sign(signingInput, CoinType.NEAR, SigningOutput.parser())
        return Numeric.toHexString(output.signedTransaction.toByteArray())
    }
}
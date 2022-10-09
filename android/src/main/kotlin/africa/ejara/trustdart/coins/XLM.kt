package africa.ejara.trustdart.coins

import com.google.protobuf.ByteString
import wallet.core.java.AnySigner
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet
import africa.ejara.trustdart.Coin
import africa.ejara.trustdart.Numeric
import africa.ejara.trustdart.utils.base64String
import africa.ejara.trustdart.utils.toHexByteArray
import wallet.core.jni.proto.Stellar
import wallet.core.jni.proto.Stellar.SigningOutput
import wallet.core.jni.StellarPassphrase
import android.util.Log
import wallet.core.jni.PrivateKey
import wallet.core.jni.proto.Stellar.Asset.Builder;




class XLM : Coin("XLM", CoinType.STELLAR) {

    override fun getPublicKey(path: String, mnemonic: String, passphrase: String): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType, path).publicKeyEd25519.data().base64String()
    }

    override fun getRawPublicKey(path: String, mnemonic: String, passphrase: String): ByteArray? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType, path).publicKeyEd25519.data()
    }

    override fun signTransaction(
        path: String,
        txData: Map<String, Any>,
        mnemonic: String,
        pass_phrase: String
    ): String? {
        val cmd = txData["cmd"] as String
        val secretKey = HDWallet(mnemonic, pass_phrase).getKey(coinType, path)
        val txHash: String?
        when (cmd) {
            "CreateAsset" -> {
                val assetUsdt = Stellar.Asset.newBuilder()
                assetUsdt.apply {
                    issuer = txData["toAddress"] as String
                    alphanum4 = txData["assetCode"] as String
                }
                val operation = Stellar.OperationChangeTrust.newBuilder()
                operation.apply {
                    asset = assetUsdt.build()
                    validBefore = (txData["validBefore"] as Int).toLong()  // till when the asset trust is valid (timestamp)
                }
                val signingInput = Stellar.SigningInput.newBuilder()
                signingInput.apply {
                    account = txData["ownerAddress"] as String
                    fee = txData["fee"] as Int
                    sequence = (txData["sequence"] as Long).toLong()
                    passphrase = StellarPassphrase.STELLAR.toString()
                    opChangeTrust = operation.build()
                    privateKey = ByteString.copyFrom(secretKey.data())
                }
                val output = AnySigner.sign(signingInput.build(), coinType, SigningOutput.parser())
                txHash= output.signature
            }
            "SendAsset" -> {
                val stellarAsset = Stellar.Asset.newBuilder()
                stellarAsset.apply {
                    issuer = txData["ownerAddress"] as String
                    alphanum4 = txData["asset"] as String
                }
                val operation = Stellar.OperationPayment.newBuilder()
                operation.apply {
                    destination = txData["toAddress"] as String
                    amount = (txData["amount"] as Int).toLong()
                    asset = stellarAsset.build()
                }
                val signingInput = Stellar.SigningInput.newBuilder()
                signingInput.apply {
                    account = txData["ownerAddress"] as String
                    fee = txData["fee"] as Int
                    sequence = (txData["sequence"] as Long).toLong()
                    passphrase = StellarPassphrase.STELLAR.toString()
                    opPayment = operation.build()
                    privateKey = ByteString.copyFrom(secretKey.data())
                }
                val output = AnySigner.sign(signingInput.build(), coinType, SigningOutput.parser())
                txHash = output.signature

            }
            "XLM" -> {
                val operation = Stellar.OperationPayment.newBuilder()
                operation.apply {
                    destination = txData["toAddress"] as String
                    amount = (txData["amount"] as Int).toLong()
                }
                val signingInput = Stellar.SigningInput.newBuilder()
                signingInput.apply {
                    account = txData["ownerAddress"] as String
                    fee = txData["fee"] as Int
                    sequence = (txData["sequence"] as Long).toLong()
                    passphrase = StellarPassphrase.STELLAR.toString()
                    opPayment = operation.build()
                    privateKey = ByteString.copyFrom(secretKey.data())
                    if (txData["memo"] != null) {
                        memoId = Stellar.MemoId.newBuilder().setId((txData["memo"] as Int).toLong()).build()
                    }
                }
                val output = AnySigner.sign(signingInput.build(), coinType, SigningOutput.parser())
                txHash= output.signature
            }
            else -> txHash = null;
        }
        return txHash
    }

}
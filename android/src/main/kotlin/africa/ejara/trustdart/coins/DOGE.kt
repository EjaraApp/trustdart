import africa.ejara.trustdart.Coin
import africa.ejara.trustdart.Numeric
import android.util.Log
import com.google.protobuf.ByteString
import wallet.core.java.AnySigner
import wallet.core.jni.BitcoinAddress
import wallet.core.jni.BitcoinScript
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet
import wallet.core.jni.proto.Bitcoin

class DOGE : Coin("DOGE", CoinType.DOGECOIN ) {

    override fun signTransaction(           
        path: String,
        txData: Map<String, Any>,
        mnemonic: String,
        passphrase: String
    ): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val privateKey = wallet.getKey(coinType, path)
        val publicKey = privateKey.getPublicKeySecp256k1(true)
        val address = BitcoinAddress(publicKey, coinType!!.p2pkhPrefix())

        val input = Bitcoin.SigningInput.newBuilder()
            .setToAddress(txData["toAddress"] as String)
            .setChangeAddress(address.toString())
            .setHashType(BitcoinScript.hashTypeForCoin(coinType))
            .setAmount((txData["amount"] as Int).toLong())
            .setCoinType(CoinType.DOGECOIN.value())
            .setByteFee(1)
            .setUseMaxAmount(false)

        input.addPrivateKey(ByteString.copyFrom(privateKey.data()))

        val txHash = Numeric.hexStringToByteArray(txData["txid"] as String);
        txHash.reverse();
        val outpoint0 = Bitcoin.OutPoint.newBuilder()
            .setHash(ByteString.copyFrom(txHash))
            .setIndex(txData["vout"] as Int)
            .setSequence(Long.MAX_VALUE.toInt())
            .build()

        val txScript = Numeric.hexStringToByteArray(txData["script"] as String);

        val utxo0 = Bitcoin.UnspentTransaction.newBuilder()
            .setAmount((txData["value"] as Int).toLong())
            .setOutPoint(outpoint0)
            .setScript(ByteString.copyFrom(txScript))
            .build()

        input.addUtxo(utxo0);

        var output = AnySigner.sign(input.build(), coinType, Bitcoin.SigningOutput.parser())


        return Numeric.toHexString(output.encoded.toByteArray())
    }
}


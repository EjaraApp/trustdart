import africa.ejara.trustdart.Coin
import africa.ejara.trustdart.Numeric
import africa.ejara.trustdart.utils.toHex
import africa.ejara.trustdart.utils.toLong
import com.google.protobuf.ByteString
import wallet.core.java.AnySigner
import wallet.core.jni.BitcoinAddress
import wallet.core.jni.BitcoinScript
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet
import wallet.core.jni.proto.Bitcoin

 


class BTC : Coin("BTC", CoinType.BITCOIN) {

    override fun generateAddress(
        path: String,
        mnemonic: String,
        passphrase: String
    ): Map<String, String>? {
        val wallet = HDWallet(mnemonic, passphrase)
        val privateKey = wallet.getKey(coinType, path)
        val publicKey = privateKey.getPublicKeySecp256k1(true)
        val address = BitcoinAddress(publicKey, coinType!!.p2pkhPrefix())
        return mapOf(
            "legacy" to address.description(),
            "segwit" to coinType!!.deriveAddress(privateKey)
        )
    }

    override fun signTransaction(
        path: String,
        txData: Map<String, Any>,
        mnemonic: String,
        passphrase: String
    ): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val privateKey = wallet.getKey(coinType, path)
        val utxos: List<Map<String, Any>> = txData["utxos"] as List<Map<String, Any>>

        val input = Bitcoin.SigningInput.newBuilder()
            .setAmount(txData["amount"]!!.toLong())
            .setHashType(BitcoinScript.hashTypeForCoin(coinType))
            .setToAddress(txData["toAddress"] as String)
            .setChangeAddress(txData["changeAddress"] as String)
            .setByteFee(1)
            .addPrivateKey(ByteString.copyFrom(privateKey.data()))

        for (utx in utxos) {
            val txHash = Numeric.hexStringToByteArray(utx["txid"] as String)
            txHash.reverse()
            val outPoint = Bitcoin.OutPoint.newBuilder()
                .setHash(ByteString.copyFrom(txHash))
                .setIndex(utx["vout"] as Int)
                .setSequence(Long.MAX_VALUE.toInt())
                .build()
            val txScript = Numeric.hexStringToByteArray(utx["script"] as String)
            val utxo = Bitcoin.UnspentTransaction.newBuilder()
                .setAmount(utx["value"]!!.toLong())
                .setOutPoint(outPoint)
                .setScript(ByteString.copyFrom(txScript))
                .build()
            input.addUtxo(utxo)
        }

        var output = AnySigner.sign(input.build(), coinType, Bitcoin.SigningOutput.parser())
        // since we want to set our own fee
        // but such functionality is not obvious in the trustwalletcore library
        // a hack is used for now to calculate the byteFee
        val size = output.encoded.toByteArray().size
        val fees = txData["fees"]!!.toLong()
        if (size > 0) { // prevent division by zero
            val byteFee = fees.div(size) // this gives the fee per byte truncated to Long
            // now we set new byte size
            if (byteFee > 1) input.byteFee = byteFee
        }
        output = AnySigner.sign(input.build(), coinType, Bitcoin.SigningOutput.parser())
        return Numeric.toHexString(output.encoded.toByteArray())
    }


    override fun multiSignTransaction(
        txData: Map<String, Any>,
        privateKeys: ArrayList<String>
    ): String? {
        val utxos: List<Map<String, Any>> = txData["utxos"] as List<Map<String, Any>>

        val input = Bitcoin.SigningInput.newBuilder()
            .setAmount(txData["amount"]!!.toLong())
            .setHashType(BitcoinScript.hashTypeForCoin(coinType))
            .setToAddress(txData["toAddress"] as String)
            .setChangeAddress(txData["changeAddress"] as String)
            .setByteFee(1)

        val byteStrings: MutableList<ByteString> = privateKeys.map { ByteString.copyFrom(Numeric.hexStringToByteArray(it)) }.toMutableList()

        input.addAllPrivateKey(byteStrings);

        for (utx in utxos) {
            val txHash = Numeric.hexStringToByteArray(utx["txid"] as String)
            txHash.reverse()
            val outPoint = Bitcoin.OutPoint.newBuilder()
                .setHash(ByteString.copyFrom(txHash))
                .setIndex(utx["vout"] as Int)
                .setSequence(Long.MAX_VALUE.toInt())
                .build()
            val txScript = Numeric.hexStringToByteArray(utx["script"] as String)
            val utxo = Bitcoin.UnspentTransaction.newBuilder()
                .setAmount(utx["value"]!!.toLong())
                .setOutPoint(outPoint)
                .setScript(ByteString.copyFrom(txScript))
                .build()
            input.addUtxo(utxo)
        }

        var output = AnySigner.sign(input.build(), coinType, Bitcoin.SigningOutput.parser())

        // since we want to set our own fee
        // but such functionality is not obvious in the trustwalletcore library
        // a hack is used for now to calculate the byteFee
        val size = output.encoded.toByteArray().size
        val fees = txData["fees"]!!.toLong()
        if (size > 0) { // prevent division by zero
            val byteFee = fees.div(size) // this gives the fee per byte truncated to Long
            // now we set new byte size
            if (byteFee > 1) input.byteFee = byteFee
        }
        output = AnySigner.sign(input.build(), coinType, Bitcoin.SigningOutput.parser())
        return Numeric.toHexString(output.encoded.toByteArray())
    }

};
           
import africa.ejara.trustdart.Coin
import africa.ejara.trustdart.Numeric
import africa.ejara.trustdart.utils.toHexByteArray
import africa.ejara.trustdart.utils.toHexBytesInByteString
import com.google.protobuf.ByteString
import wallet.core.java.AnySigner
import wallet.core.jni.BitcoinAddress
import wallet.core.jni.BitcoinScript
import wallet.core.jni.BitcoinSigHashType
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
         val utxos: List<Map<String, Any>> = txData["utxos"] as List<Map<String, Any>>

         val script = BitcoinScript.lockScriptForAddress(address.description(), coinType)

         val input = Bitcoin.SigningInput.newBuilder()
         .setAmount((txData["amount"] as Int).toLong())
         .setHashType(BitcoinSigHashType.ALL.value())
         .setToAddress(txData["toAddress"] as String)
         .setChangeAddress(txData["changeAddress"] as String)
         .setByteFee((txData["fees"] as Int).toLong())
         .setCoinType(CoinType.DOGECOIN.value())
         .addPrivateKey(ByteString.copyFrom(privateKey.data()))

    
        for (utx in utxos) {
            val txId = Numeric.hexStringToByteArray(utx["txid"] as String)
            val outPoint = Bitcoin.OutPoint.newBuilder()
                .setHash(ByteString.copyFrom(txId.reversedArray()))
                .setIndex(utx["vout"] as Int)
                .build()

            val utxo = Bitcoin.UnspentTransaction.newBuilder()
                .setAmount(utx["value"] as Long)
                .setOutPoint(outPoint)
                .setScript(ByteString.copyFrom(script.data()))
                .build()

            input.addUtxo(utxo)
        }

        val output = AnySigner.sign(input.build(), coinType, Bitcoin.SigningOutput.parser())

         return Numeric.toHexString(output.encoded.toByteArray())
     }

}


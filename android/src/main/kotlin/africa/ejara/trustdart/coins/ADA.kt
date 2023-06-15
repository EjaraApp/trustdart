import africa.ejara.trustdart.Coin
import africa.ejara.trustdart.Numeric
import africa.ejara.trustdart.utils.toLong
import com.google.protobuf.ByteString
import io.flutter.Log
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet
import wallet.core.jni.proto.Cardano
import wallet.core.java.AnySigner

 

class ADA : Coin("ADA", CoinType.CARDANO){

    override fun signTransaction(
        path: String,
        txData: Map<String, Any>,
        mnemonic: String,
        passphrase: String
    ): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val privateKey = wallet.getKey(coinType, path)
        val listOfAllUtxos = mutableListOf<Cardano.TxInput>();
        val utxos: List<Map<String, Any>> = txData["utxos"] as List<Map<String, Any>>
        val message = Cardano.Transfer.newBuilder()
            .setToAddress(txData["receiverAddress"] as String)
            .setChangeAddress(txData["senderAddress" ] as String)
            .setAmount(txData["amount"]!!.toLong())
            .build()
        val input = Cardano.SigningInput.newBuilder()
            .setTransferMessage(message)
            .setTtl(53333333)

        input.addPrivateKey(ByteString.copyFrom(privateKey.data()))
        for (utx in utxos) {
            val outpoint1 = Cardano.OutPoint.newBuilder()
                .setTxHash(ByteString.copyFrom(Numeric.hexStringToByteArray(utx["txid"] as String)))
                .setOutputIndex(utx["index"]!!.toLong())
                .build()
            val utxo1 = Cardano.TxInput.newBuilder()
                .setOutPoint(outpoint1)
                .setAddress(utx["senderAddress"] as String)
                .setAmount(utx["amount"]!!.toLong())
                .build()
            listOfAllUtxos.add(utxo1)
        }
        input.addAllUtxos(listOfAllUtxos)

        val output = AnySigner.sign(input.build(), coinType, Cardano.SigningOutput.parser())
        return Numeric.toHexString(output.encoded.toByteArray())
    }
}
import africa.ejara.trustdart.Coin
import africa.ejara.trustdart.Numeric
import africa.ejara.trustdart.utils.base64String
import africa.ejara.trustdart.utils.toHex
import africa.ejara.trustdart.utils.toHexBytes
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet
import wallet.core.jni.Hash
import wallet.core.jni.proto.Tezos.*
import com.google.protobuf.ByteString
import wallet.core.jni.CoinType.TEZOS
import wallet.core.java.AnySigner
import wallet.core.jni.proto.Tezos

class XTZ : Coin("XTZ", CoinType.TEZOS) {

    override fun getPublicKey(path: String, mnemonic: String, passphrase: String): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType, path).publicKeyEd25519.data().base64String()
    }

    override fun getRawPublicKey(path: String, mnemonic: String, passphrase: String): ByteArray? {
        val wallet = HDWallet(mnemonic, passphrase)
        return wallet.getKey(coinType, path)
            .publicKeyEd25519.data()
    }

    override fun signDataWithPrivateKey(
        path: String,
        mnemonic: String,
        passphrase: String,
        txData: String
    ): String? {
        val wallet = HDWallet(mnemonic, passphrase)
        val privateKey = wallet.getKey(coinType, path)
        val hash: ByteArray? = Hash.blake2b(txData.toHexBytes(), 32)
        return privateKey.sign(hash, coinType!!.curve()).toHex()
    }

    override fun signTransaction(
        path: String,
        txData: Map<String, Any>,
        mnemonic: String,
        passphrase: String
    ): String? {
        val cmd = txData["cmd"] as String
        val txHash: String?
        val wallet = HDWallet(mnemonic, passphrase)
        val privateKey = ByteString.copyFrom(wallet.getKey(coinType, path).data())

        when (cmd) {
            "FA2" -> {
                val transferInfos = Txs.newBuilder()
                    .setAmount(txData["amount"] as String)
                    .setTokenId(txData["tokenId"] as String)
                    .setTo(txData["toAddress"] as String)
                    .build()

                val txObj = TxObject.newBuilder()
                    .setFrom(txData["senderAddress"] as String)
                    .addTxs(transferInfos)
                    .build()

                val fa2 = FA2Parameters.newBuilder()
                    .setEntrypoint("transfer")
                    .addTxsObject(txObj)
                    .build()

                val parameters = OperationParameters.newBuilder()
                    .setFa2Parameters(fa2)
                    .build()

                val transactionData = TransactionOperationData.newBuilder()
                    .setAmount((txData["transactionAmount"] as Int).toLong())
                    .setDestination(txData["destination"] as String)
                    .setParameters(parameters)
                    .build()

                val transaction = Operation.newBuilder()
                    .setSource(txData["source"] as String)
                    .setFee((txData["fee"] as Int).toLong())
                    .setCounter((txData["counter"] as Int).toLong())
                    .setGasLimit((txData["gasLimit"] as Int).toLong())
                    .setStorageLimit((txData["storageLimit"] as Int).toLong())
                    .setKind(Operation.OperationKind.TRANSACTION)
                    .setTransactionOperationData(transactionData)
                    .build()

                val operationList = OperationList.newBuilder()
                    .setBranch(txData["branch"] as String)
                    .addOperations(transaction)
                    .build();

                val signingInput = SigningInput.newBuilder()
                    .setPrivateKey(privateKey)
                    .setOperationList(operationList)
                    .build()

                val result = AnySigner.sign(signingInput, TEZOS, Tezos.SigningOutput.parser())
                txHash = Numeric.toHexString(result.encoded.toByteArray())
            }
            "FA12" -> {
                val fa12 = FA12Parameters.newBuilder()
                    .setEntrypoint("transfer")
                    .setFrom(txData["senderAddress"] as String)
                    .setTo(txData["toAddress"] as String)
                    .setValue(txData["value"] as String)
                    .build()

                val parameters = OperationParameters.newBuilder()
                    .setFa12Parameters(fa12)
                    .build()

                val transactionData = TransactionOperationData.newBuilder()
                    .setAmount(0)
                    .setDestination(txData["destination"] as String)
                    .setParameters(parameters)
                    .build()

                val transaction = Operation.newBuilder()
                    .setSource(txData["source"] as String)
                    .setFee((txData["fee"] as Int).toLong())
                    .setCounter((txData["counter"] as Int).toLong())
                    .setGasLimit((txData["gasLimit"] as Int).toLong())
                    .setStorageLimit((txData["storageLimit"] as Int).toLong())
                    .setKind(Operation.OperationKind.TRANSACTION)
                    .setTransactionOperationData(transactionData)
                    .build();

                val operationList = OperationList.newBuilder()
                    .setBranch(txData["branch"] as String)
                    .addOperations(transaction)
                    .build();

                val signingInput = SigningInput.newBuilder()
                    .setPrivateKey(privateKey)
                    .setOperationList(operationList)
                    .build()

                val result = AnySigner.sign(signingInput, TEZOS, Tezos.SigningOutput.parser())
                txHash = Numeric.toHexString(result.encoded.toByteArray())

            }
            else -> txHash = null;
        }
        return txHash
    }


}
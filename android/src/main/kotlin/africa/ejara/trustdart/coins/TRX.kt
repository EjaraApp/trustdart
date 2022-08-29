import africa.ejara.trustdart.Coin
import africa.ejara.trustdart.Numeric
import com.google.protobuf.ByteString
import wallet.core.java.AnySigner
import wallet.core.jni.CoinType
import wallet.core.jni.HDWallet
import wallet.core.jni.proto.Tron

class TRX : Coin("TRX", CoinType.TRON) {

    override fun signTransaction(
        path: String,
        txData: Map<String, Any>,
        mnemonic: String,
        passphrase: String
    ): String? {
        val cmd = txData["cmd"] as String
        val wallet = HDWallet(mnemonic, passphrase)
        val privateKey = wallet.getKey(coinType, path)
        val txHash: String?;
        when (cmd) {
            "TRC20" -> {
                val trc20Contract = Tron.TransferTRC20Contract.newBuilder()
                    .setOwnerAddress(txData["ownerAddress"] as String)
                    .setContractAddress(txData["contractAddress"] as String)
                    .setToAddress(txData["toAddress"] as String)
                    .setAmount(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["amount"] as String))))

                val blockHeader = Tron.BlockHeader.newBuilder()
                    .setTimestamp(txData["blockTime"] as Long)
                    .setTxTrieRoot(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["txTrieRoot"] as String))))
                    .setParentHash(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["parentHash"] as String))))
                    .setNumber((txData["number"] as Int).toLong())
                    .setWitnessAddress(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["witnessAddress"] as String))))
                    .setVersion(txData["version"] as Int)
                    .build()

                val transaction = Tron.Transaction.newBuilder()
                    .setTimestamp(txData["timestamp"] as Long)
                    .setTransferTrc20Contract(trc20Contract)
                    .setBlockHeader(blockHeader)
                    .setFeeLimit((txData["feeLimit"] as Int).toLong())
                    .build()

                val signingInput = Tron.SigningInput.newBuilder()
                    .setTransaction(transaction)
                    .setPrivateKey(ByteString.copyFrom(privateKey.data()))

                val output =
                    AnySigner.sign(signingInput.build(), coinType, Tron.SigningOutput.parser())
                txHash = output.json
            }
            "TRC10" -> {
                val trc10Contract = Tron.TransferAssetContract.newBuilder()
                    .setOwnerAddress(txData["ownerAddress"] as String)
                    .setAssetName(txData["assetName"] as String)
                    .setToAddress(txData["toAddress"] as String)
                    .setAmount((txData["amount"] as Int).toLong())

                val blockHeader = Tron.BlockHeader.newBuilder()
                    .setTimestamp(txData["blockTime"] as Long)
                    .setTxTrieRoot(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["txTrieRoot"] as String))))
                    .setParentHash(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["parentHash"] as String))))
                    .setNumber((txData["number"] as Int).toLong())
                    .setWitnessAddress(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["witnessAddress"] as String))))
                    .setVersion(txData["version"] as Int)
                    .build()

                val transaction = Tron.Transaction.newBuilder()
                    .setTimestamp(txData["timestamp"] as Long)
                    .setTransferAsset(trc10Contract)
                    .setBlockHeader(blockHeader)
                    .build()

                val signingInput = Tron.SigningInput.newBuilder()
                    .setTransaction(transaction)
                    .setPrivateKey(ByteString.copyFrom(privateKey.data()))

                val output =
                    AnySigner.sign(signingInput.build(), coinType, Tron.SigningOutput.parser())
                txHash = output.json
            }
            "TRX" -> {
                val transfer = Tron.TransferContract.newBuilder()
                    .setOwnerAddress(txData["ownerAddress"] as String)
                    .setToAddress(txData["toAddress"] as String)
                    .setAmount((txData["amount"] as Int).toLong())

                val blockHeader = Tron.BlockHeader.newBuilder()
                    .setTimestamp(txData["blockTime"] as Long)
                    .setTxTrieRoot(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["txTrieRoot"] as String))))
                    .setParentHash(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["parentHash"] as String))))
                    .setNumber((txData["number"] as Int).toLong())
                    .setWitnessAddress(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["witnessAddress"] as String))))
                    .setVersion(txData["version"] as Int)
                    .build()

                val transaction = Tron.Transaction.newBuilder()
                    .setTimestamp(txData["timestamp"] as Long)
                    .setTransfer(transfer)
                    .setBlockHeader(blockHeader)
                    .setFeeLimit((txData["feeLimit"] as Int).toLong())
                    .build()

                val signingInput = Tron.SigningInput.newBuilder()
                    .setTransaction(transaction)
                    .setPrivateKey(ByteString.copyFrom(privateKey.data()))

                val output =
                    AnySigner.sign(signingInput.build(), coinType, Tron.SigningOutput.parser())
                txHash = output.json
            }
            "FREEZE" -> {
                val freezeContract = Tron.FreezeBalanceContract.newBuilder()
                    .setOwnerAddress(txData["ownerAddress"] as String)
                    .setResource(txData["resource"] as String)
                    .setFrozenDuration((txData["frozenDuration"] as Int).toLong())
                    .setFrozenBalance((txData["frozenBalance"] as Int).toLong())

                val blockHeader = Tron.BlockHeader.newBuilder()
                    .setTimestamp(txData["blockTime"] as Long)
                    .setTxTrieRoot(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["txTrieRoot"] as String))))
                    .setParentHash(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["parentHash"] as String))))
                    .setNumber((txData["number"] as Int).toLong())
                    .setWitnessAddress(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["witnessAddress"] as String))))
                    .setVersion(txData["version"] as Int)
                    .build()

                val transaction = Tron.Transaction.newBuilder()
                    .setTimestamp(txData["timestamp"] as Long)
                    .setFreezeBalance(freezeContract)
                    .setBlockHeader(blockHeader)
                    .build()

                val signingInput = Tron.SigningInput.newBuilder()
                    .setTransaction(transaction)
                    .setPrivateKey(ByteString.copyFrom(privateKey.data()))

                val output =
                    AnySigner.sign(signingInput.build(), coinType, Tron.SigningOutput.parser())
                txHash = output.json
            }
            "CONTRACT" -> {
                txHash = null
            }
            else -> txHash = null;
        }
        return txHash;
    }
}
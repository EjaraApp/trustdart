import africa.ejara.trustdart.Coin
import africa.ejara.trustdart.Numeric
import africa.ejara.trustdart.utils.toLong
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
        val txHash: String?
        when (cmd) {
            "TRC20" -> {
                val trc20Contract = Tron.TransferTRC20Contract.newBuilder()
                    .setOwnerAddress(txData["ownerAddress"] as String)
                    .setContractAddress(txData["contractAddress"] as String)
                    .setToAddress(txData["toAddress"] as String)
                    .setAmount(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["amount"] as String))))

                val blockHeader = Tron.BlockHeader.newBuilder()
                    .setTimestamp(txData["blockTime"]!!.toLong())
                    .setTxTrieRoot(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["txTrieRoot"] as String))))
                    .setParentHash(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["parentHash"] as String))))
                    .setNumber(txData["number"]!!.toLong())
                    .setWitnessAddress(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["witnessAddress"] as String))))
                    .setVersion(txData["version"] as Int)
                    .build()

                val transaction = Tron.Transaction.newBuilder()
                    .setTransferTrc20Contract(trc20Contract)
                    .setTimestamp(txData["timestamp"]!!.toLong())
                    .setFeeLimit(txData["feeLimit"]!!.toLong())
                    .setBlockHeader(blockHeader)
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
                    .setAmount(txData["amount"]!!.toLong())

                val blockHeader = Tron.BlockHeader.newBuilder()
                    .setTimestamp(txData["blockTime"]!!.toLong())
                    .setTxTrieRoot(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["txTrieRoot"] as String))))
                    .setParentHash(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["parentHash"] as String))))
                    .setNumber(txData["number"]!!.toLong())
                    .setWitnessAddress(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["witnessAddress"] as String))))
                    .setVersion(txData["version"] as Int)
                    .build()

                val transaction = Tron.Transaction.newBuilder()
                    .setTransferAsset(trc10Contract)
                    .setTimestamp(txData["timestamp"]!!.toLong())
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
                    .setAmount(txData["amount"]!!.toLong())

                val blockHeader = Tron.BlockHeader.newBuilder()
                    .setTimestamp(txData["blockTime"]!!.toLong())
                    .setTxTrieRoot(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["txTrieRoot"] as String))))
                    .setParentHash(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["parentHash"] as String))))
                    .setNumber(txData["number"]!!.toLong())
                    .setWitnessAddress(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["witnessAddress"] as String))))
                    .setVersion(txData["version"] as Int)
                    .build()

                val transaction = Tron.Transaction.newBuilder()
                    .setTimestamp(txData["timestamp"]!!.toLong())
                    .setFeeLimit(txData["feeLimit"]!!.toLong())
                    .setTransfer(transfer)
                    .setBlockHeader(blockHeader)
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
                    .setFrozenDuration(txData["frozenDuration"]!!.toLong())
                    .setFrozenBalance(txData["frozenBalance"]!!.toLong())

                val blockHeader = Tron.BlockHeader.newBuilder()
                    .setTimestamp(txData["blockTime"]!!.toLong())
                    .setTxTrieRoot(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["txTrieRoot"] as String))))
                    .setParentHash(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["parentHash"] as String))))
                    .setNumber(txData["number"]!!.toLong())
                    .setWitnessAddress(ByteString.copyFrom(Numeric.hexStringToByteArray((txData["witnessAddress"] as String))))
                    .setVersion(txData["version"] as Int)
                    .build()

                val transaction = Tron.Transaction.newBuilder()
                    .setTimestamp(txData["timestamp"]!!.toLong())
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
            else -> txHash = null
        }
        return txHash
    }

}
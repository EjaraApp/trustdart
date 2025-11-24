import africa.ejara.trustdart.Coin
import africa.ejara.trustdart.enums.CoinType
import android.R.attr.path
import com.swmansion.starknet.account.StandardAccount
import com.swmansion.starknet.crypto.starknetKeccak
import com.swmansion.starknet.crypto.StarknetCurve
import com.swmansion.starknet.data.ContractAddressCalculator
import com.swmansion.starknet.data.types.DeployAccountParamsV3
import com.swmansion.starknet.data.types.Felt
import com.swmansion.starknet.data.types.ResourceBounds
import com.swmansion.starknet.data.types.ResourceBoundsMapping
import com.swmansion.starknet.data.types.StarknetChainId
import com.swmansion.starknet.data.types.Uint128
import com.swmansion.starknet.data.types.Uint64
import com.swmansion.starknet.extensions.toFelt
import com.swmansion.starknet.provider.rpc.JsonRpcProvider


class STRK : Coin<String, CoinType>("STRK", CoinType.STRK) {
    override fun generateAddress(
        accountContractClassHash: String,
        mnemonic: String,
        passphrase: String
    ): Map<String, String>? {
        val addressContractParams = this.getAddressContractParams(accountContractClassHash, mnemonic, passphrase)
        val address = ContractAddressCalculator.calculateAddressFromHash(
            classHash = addressContractParams!!["classHash"] as Felt,
            calldata = addressContractParams["callData"] as List<Felt>,
            salt = addressContractParams["salt"] as Felt
        )
        return mapOf("legacy" to address.hexString())
    }

    private fun getAddressContractParams(accountContractClassHash: String,
                                         mnemonic: String,
                                         passphrase: String): Map<String, Any>? {
        val callData = listOf(this.getPublicKey(accountContractClassHash, mnemonic, passphrase)!!.toFelt)

        return mapOf("classHash" to accountContractClassHash.toFelt, "callData" to callData, "salt" to passphrase.toFelt)
    }

    override fun getPrivateKey(path: String, mnemonic: String, passphrase: String): String? {
        return starknetKeccak(this.getSeed(path, mnemonic, passphrase)!!).hexString()
    }

    // getSeed; implemented

    override fun getRawPrivateKey(path: String, mnemonic: String, passphrase: String): ByteArray? {
        return this.getPrivateKey(path, mnemonic, passphrase)!!.toByteArray()
    }

    override fun getPublicKey(path: String, mnemonic: String, passphrase: String): String? {
        val privateKey = this.getPrivateKey(path, mnemonic, passphrase)
        return StarknetCurve.getPublicKey(Felt.fromHex(privateKey!!)).hexString()
    }

    override fun getRawPublicKey(path: String, mnemonic: String, passphrase: String): ByteArray? {
        return this.getPublicKey(path, mnemonic, passphrase)!!.toByteArray()
    }

    // validateAddress; implemented

    override fun signDataWithPrivateKey(
        path: String,
        mnemonic: String,
        passphrase: String,
        txData: String
    ): String? {
        return "" // TODO
    }

    override fun signTransaction(
        accountContractClassHash: String,
        txData: Map<String, Any>,
        mnemonic: String,
        passphrase: String
    ): String? {
        return "" // TODO
    }

    override fun multiSignTransaction(
        txData: Map<String, Any>,
        privateKeys: ArrayList<String>
    ): String? {
        return "" // TODO
    }
}
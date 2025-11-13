import africa.ejara.trustdart.Coin
import africa.ejara.trustdart.enums.CoinType
import com.swmansion.starknet.crypto.starknetKeccak
import com.swmansion.starknet.crypto.StarknetCurve
import com.swmansion.starknet.data.types.Felt


class STRK : Coin<String, CoinType>("STRK", CoinType.STRK) {
    override fun generateAddress(
        path: String,
        mnemonic: String,
        passphrase: String
    ): Map<String, String>? {
        return mapOf("legacy" to this.getPublicKey(path, mnemonic, passphrase)!!)
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
        path: String,
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
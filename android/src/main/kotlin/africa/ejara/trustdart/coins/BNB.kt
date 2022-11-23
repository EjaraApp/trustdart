package africa.ejara.trustdart.coins

import africa.ejara.trustdart.Coin
import com.google.protobuf.ByteString
import wallet.core.jni.*
import wallet.core.jni.CoinType.BINANCE
import wallet.core.java.AnySigner
import wallet.core.jni.proto.Binance
import wallet.core.jni.proto.Binance.SigningOutput
import africa.ejara.trustdart.utils.base64String



class BNB : Coin("BNB", CoinType.BINANCE) {

    // override fun getPublicKey(path: String, mnemonic: String, passphrase: String): String? {
    //     val wallet = HDWallet(mnemonic, passphrase)
    //     return wallet.getKey(coinType, path).getPublicKeySecp256k1(true).data().base64String()
    // }
    // override fun getRawPublicKey(path: String, mnemonic: String, passphrase: String): ByteArray? {
    //     val wallet = HDWallet(mnemonic, passphrase)
    //     return wallet.getKey(coinType, path).getPublicKeySecp256k1(true).data()
    // }

    override fun signTransaction(           
        path: String,
        txData: Map<String, Any>,
        mnemonic: String,
        passphrase: String
    ): String? {
        val txHash: String?
        val wallet = HDWallet(mnemonic, passphrase)
        val privateKey = wallet.getKey(coinType, path)
        val publicKey = privateKey.getPublicKeySecp256k1(true)
        val signingInput = Binance.SigningInput.newBuilder()
        signingInput.chainId = (txData["chainID"] as Int).toLong()
        signingInput.accountNumber = (txData["accountNumber"] as Int).toLong()
        signingInput.sequence = (txData["sequence"] as Int).toLong()

        signingInput.privateKey = ByteString.copyFrom(privateKey.data())

        val token = Binance.SendOrder.Token.newBuilder()
        token.denom = "BNB"
        token.amount = (txData["amount"] as Int).toLong()

        val input = Binance.SendOrder.Input.newBuilder()
        input.address = ByteString.copyFrom(AnyAddress(publicKey, BINANCE).data())
        input.addAllCoins(listOf(token.build()))

        val output =  Binance.SendOrder.Output.newBuilder()
        output.address = ByteString.copyFrom(AnyAddress(txData["toAddress"] as String, BINANCE).data())
        output.addAllCoins(listOf(token.build()))

        val sendOrder = Binance.SendOrder.newBuilder()
        sendOrder.addAllInputs(listOf(input.build()))
        sendOrder.addAllOutputs(listOf(output.build()))

        signingInput.sendOrder = sendOrder.build()

        val sign: Binance.SigningOutput = AnySigner.sign(signingInput.build(), BINANCE, SigningOutput.parser())
        txHash= sign.encoded.toByteArray().base64String();
        return txHash

    }

}

// fromAddress
// toAddress
// amount
// memo(optional)

// {"type":"bnbchain/Account","value":{"base":{"address":"tbnb1sylyjw032eajr9cyllp26n04300qzzre38qyv5","coins":[{"denom":"000-0E1","amount":"10530"},{"denom":"BNB","amount":"247349863800"},{"denom":"BTC.B-918","amount":"113218800"},{"denom":"COSMOS-587","amount":"50000101983748977"},{"denom":"EDU-DD0","amount":"139885964"},{"denom":"MFH-9B5","amount":"1258976083286"},{"denom":"NASC-137","amount":"0"},{"denom":"PPC-00A","amount":"205150260"},{"denom":"TGT-9FC","amount":"33251102828"},{"denom":"UCX-CC8","amount":"1398859649"},{"denom":"USDT.B-B7C","amount":"140456966268"},{"denom":"YLC-D8B","amount":"210572645"},{"denom":"ZZZ-21E","amount":"13988596"}],"public_key":{"type":"tendermint/PubKeySecp256k1","value":"AhOb3ZXecsIqwqKw+HhTscyi6K35xYpKaJx10yYwE0Qa"},"account_number":"406226","sequence":"29"},"name":"","frozen":null,"locked":[{"denom":"KOGE48-35D","amount":"10000000000"}]}}
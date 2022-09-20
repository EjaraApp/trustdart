/*
 XLM
 */
import WalletCore

class XLM: Coin  {
    init() {
        super.init(name: "XLM", coinType: .stellar)
    }
    
    override func getPublicKey(path: String, mnemonic: String, passphrase: String) -> String? {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        return wallet!.getKey(coin: self.coinType, derivationPath: path).getPublicKeyEd25519().data.base64EncodedString()
    }

    override func getRawPublicKey(path: String, mnemonic: String, passphrase: String) -> FlutterStandardTypedData {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        return FlutterStandardTypedData(bytes: wallet!.getKey(coin: self.coinType, derivationPath: path).getPublicKeyEd25519().data)
    }
    
    override func signTransaction(path: String, txData: [String : Any], mnemonic: String, passphrase: String) -> String? {
        let privateKey = HDWallet(mnemonic: mnemonic, passphrase: passphrase)?.getKey(coin: self.coinType, derivationPath: path)
        
        let operation = StellarOperationPayment.with {
            $0.destination = txData["toAddress"] as String
            $0.amount = (txData["amount"] as Int).toLong()
        }
        let input = StellarSigningInput.with {
            $0.passphrase = StellarPassphrase.stellar.description
            $0.fee = (txData["fee"] as Int).toLong()
            $0.sequence = (txData["sequence"] as Int).toLong() // from account info api
            $0.account = txData["ownerAddress"] as String
            $0.privateKey = privateKey!.data
            $0.opPayment = operation
        }
        
        let output: StellarSigningOutput = AnySigner.sign(input: input, coin: .stellar)
        return output.signature.hexString
        
    }
}

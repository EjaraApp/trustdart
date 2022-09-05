/*
 XTZ
 */
import WalletCore

class XTZ: Coin  {
    init() {
        super.init(name: "XTZ", coinType: .tezos)
    }
    
    override func getPublicKey(path: String, mnemonic: String, passphrase: String) -> String? {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        return wallet!.getKey(coin: self.coinType, derivationPath: path).getPublicKeyEd25519().data.base64EncodedString()
    }
    
    override func getRawPublicKey(path: String, mnemonic: String, passphrase: String) -> FlutterStandardTypedData {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        return FlutterStandardTypedData(bytes: wallet!.getKey(coin: self.coinType, derivationPath: path).getPublicKeyEd25519().data)
    }
    
    override func signDataWithPrivateKey(path: String, mnemonic: String, passphrase: String, txData: String) -> String? {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        let privateKey = wallet?.getKey(coin: self.coinType, derivationPath: path)
        let hash = Hash.blake2b(data: Data(hexString: txData)!, size: 32)
        if privateKey != nil {
            return privateKey?.sign(digest: hash, curve: self.coinType.curve)?.hexString
        }
        return nil
    }
    
}

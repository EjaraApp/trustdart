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
        let publicKey: String? = wallet!.getKey(coin: self.coinType, derivationPath: path).getPublicKeyEd25519().data.base64EncodedString()
        return publicKey
    }
    
    override func getPublicKeyRaw(path: String, mnemonic: String, passphrase: String) -> [UInt8] {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        let publicKey: [UInt8] = wallet!.getKey(coin: self.coinType, derivationPath: path).getPublicKeyEd25519().data()
        return publicKey
    }
    
    override func getSeed(path: String, mnemonic: String, passphrase: String) -> [UInt8] {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        let publicKey: [UInt8] = wallet!.getSeed()
        return publicKey
    }
}

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
    
    override func getRawPublicKey(path: String, mnemonic: String, passphrase: String) -> [UInt8] {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        return wallet!.getKey(coin: self.coinType, derivationPath: path).getPublicKeyEd25519().data.bytes
    }
    
    override func getSeed(path: String, mnemonic: String, passphrase: String) -> [UInt8] {
        let wallet = HDWallet(mnemonic: mnemonic, passphrase: passphrase)
        return wallet!.seed.bytes
    }
}

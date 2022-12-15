/*
 DOGE
 */

import WalletCore

class DOGE: Coin  {
    init() {
        super.init(name: "DOGE", coinType: .dogecoin)
    }

    // override func testDeriveFromDpub() {
    //     let dgub = "dgub8rjvUmFc6cqR6NRBEj2FBZCHUDUrykPyv24Vea6bCsPex5PzNFrRtr4KN37XgwuVzzC2MikJRW2Ddcp99Ehsqp2iaU4eerNCJVruKxz6Gci"
    //     let pubkey8 = HDWallet.getPublicKeyFromExtended(
    //         extended: dgub,
    //         coin: .dogecoin,
    //         derivationPath: DerivationPath(purpose: .bip44, coin: coin.slip44Id, account: 0, change: 0, address: 8).description
    //     )!

    //     let address = BitcoinAddress(publicKey: pubkey8, prefix: coin.p2pkhPrefix)!
    //     let p = XCTAssertEqual(address.description, "DLrjRgrVqbbpGrSQUtSYgsiWWMvRz5skQE")
    //     print("pppppppp: ", p)
        
    // }

}

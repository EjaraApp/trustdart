/*
 ETH
 */
import WalletCore

class ETH: Coin  {
    init() {
        super.init(name: "ETH", coinType: .ethereum)
    }
}

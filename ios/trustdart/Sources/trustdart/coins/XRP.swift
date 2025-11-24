//
//  XRP.swift
//  trustdart
//
//  Created by Jay on 3/11/25.
//
import Foundation
import WalletCore

class XRP: Coin  {
    init() {
        super.init(name: "XRP", coinType: .xrp)
    }
    
    override func signTransaction(path: String, txData: [String : Any], mnemonic: String, passphrase: String) -> String? {
        let privateKey = HDWallet(mnemonic: mnemonic, passphrase: passphrase)?.getKey(coin: self.coinType, derivationPath: path)
        
        let operation = RippleOperationPayment.with {
            $0.destination = txData["receiverAddress"] as! String
            $0.amount = txData["amount"] as! Int64
            if (txData["memo"] != nil) {
                $0.destinationTag = UInt32(txData["memo"] as! String)!
            }
        }
        let input = RippleSigningInput.with {
            $0.fee = txData["fee"] as! Int64
            $0.sequence = txData["sequence"] as! UInt32
            $0.lastLedgerSequence = txData["lastLedgerSequence"] as! UInt32
            $0.account = txData["senderAddress" ] as! String
            $0.privateKey = privateKey!.data
            $0.opPayment = operation
        }
        
        let output: RippleSigningOutput = AnySigner.sign(input: input, coin: .xrp)
        return output.encoded.hexString
    }
    
}

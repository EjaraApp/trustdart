//
//  WalletError.swift
//  trustdart
//
//  Created by Jay on 4/5/22.
//

import Flutter

class WalletError {
    let details: FlutterError
    required init(code: WalletHandlerErrorCodes, message: String?, details: Any?){
        self.details = FlutterError(code: code.rawValue, message: message, details: details)
    }
}

enum WalletHandlerErrorCodes: String {
    case noWallet = "no_wallet"
    case addressNull = "address_null"
    case argumentsNull = "arguments_null"
    case txHashNull = "txhash_null"
}

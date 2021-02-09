//
//  File.swift
//  
//
//  Created by Arturo Jamaica on 2021/02/08.
//

import Foundation

struct UserTrade: Decodable, Equatable {
    let book: BookSymbol
    let major: String
    let created_at: Date
    let minor: String
    let fees_amount: String
    let fees_currency: CurrencyId
    let price: String
    let tid: TradeID
    let oid: OrderID
    let side: Side
    let make_side: Side
}

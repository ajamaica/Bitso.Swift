//
//  File.swift
//  
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation
public typealias OrderID = String
public struct Ask: Equatable, Decodable {
    let book: BookSymbol
    let price: String
    let amount: String
}

public struct Bid: Equatable, Decodable {
    let book: BookSymbol
    let price: String
    let amount: String
    let oid: OrderID?
}

public struct OrderBook: Equatable, Decodable {
    let asks: [Ask]
    let bids: [Bid]
    let updated_at: Date
    let sequence: String
}

//
//  File.swift
//  
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation

public enum Side: String, Decodable {
    case sell
    case buy
}
public typealias TradeID = Int
public struct Trade: Decodable, Equatable {
    let book: BookSymbol
    let created_at: Date
    let amount: String
    let maker_side: Side
    let price: String
    let tid: TradeID
}

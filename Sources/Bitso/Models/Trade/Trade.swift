//
//  File.swift
//  
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation

public typealias TradeID = Int
struct Trade: Codable, Equatable {
    let book: BookSymbol
    let created_at: Date
    let amount: String
    let maker_side: String
    let price: String
    let tid: TradeID
}

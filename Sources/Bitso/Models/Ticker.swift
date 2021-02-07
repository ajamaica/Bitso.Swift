//
//  File.swift
//  
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation

struct Ticker: Decodable, Equatable {
    let book: String
    let volume: String
    let high: String
    let last: String
    let low: String
    let vwap: String
    let ask: String
    let bid: String
    let created_at: Date
}

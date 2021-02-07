//
//  File.swift
//  
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation

public typealias OrderID = String
public struct OrderBook: Equatable, Decodable {
    let asks: [Ask]
    let bids: [Bid]
    let updated_at: Date
    let sequence: String
}

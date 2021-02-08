//
//  File.swift
//  
//
//  Created by Arturo Jamaica on 2021/02/08.
//

import Foundation
typealias CurrencyId = String
struct Balances: Decodable, Equatable {
    let balances: [Balance]
}
struct Balance: Decodable, Equatable {
    let currency: CurrencyId
    let total: String
    let locked: String
    let available: String
}

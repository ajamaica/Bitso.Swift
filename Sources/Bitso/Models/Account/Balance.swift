//
//  File.swift
//  
//
//  Created by Arturo Jamaica on 2021/02/08.
//

import Foundation

struct Balances: Decodable, Equatable {
    let balances: [Balance]
}
struct Balance: Decodable, Equatable {
    let currency: String
    let total: String
    let locked: String
    let available: String
}

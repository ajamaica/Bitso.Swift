//
//  Book.swift
//  Bitso.Swift
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation

public typealias BookSymbol = String
public struct Book: Decodable, Equatable {
    let book: BookSymbol
    let minimum_amount: String
    let maximum_amount: String
    let minimum_price: String
    let maximum_price: String
    let minimum_value: String
    let maximum_value: String
    let tick_size: String?
    let fees: Fees
}

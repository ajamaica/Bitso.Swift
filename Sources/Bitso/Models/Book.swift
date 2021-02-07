//
//  Book.swift
//  Bitso.Swift
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation

struct Book: Decodable, Equatable {
    let book: String
    let minimum_amount: String
    let maximum_amount: String
    let minimum_price: String
    let maximum_price: String
    let minimum_value: String
    let maximum_value: String
}

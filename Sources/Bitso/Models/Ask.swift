//
//  File.swift
//  
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation

public struct Ask: Equatable, Decodable {
    let book: BookSymbol
    let price: String
    let amount: String
}

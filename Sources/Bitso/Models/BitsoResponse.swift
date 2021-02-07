//
//  BitsoResponse.swift
//  Bitso.Swift
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation

public struct BitsoResponse<Payload: Decodable>: Decodable {
    let success: Bool
    let payload: Payload?
    let error: BitsoError?
}

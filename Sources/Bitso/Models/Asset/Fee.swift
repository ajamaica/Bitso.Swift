import Foundation

public struct Fees: Decodable, Equatable {
    let flat_rate: Fee
    let structure: [StructureFee]
}

public struct Fee: Decodable, Equatable {
    let maker: String
    let taker: String
}

public struct StructureFee: Decodable, Equatable {
    let maker: String
    let taker: String
    let volume: String
}

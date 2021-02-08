import Foundation

struct Fees: Decodable, Equatable {
    let flat_rate: Fee
    let structure: [StructureFee]
}

struct Fee: Decodable, Equatable {
    let maker: String
    let taker: String
}

struct StructureFee: Decodable, Equatable {
    let maker: String
    let taker: String
    let volume: String
}

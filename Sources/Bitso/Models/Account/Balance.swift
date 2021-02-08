import Foundation

public typealias CurrencyId = String
public struct Balances: Decodable, Equatable {
    let balances: [Balance]
}
public struct Balance: Decodable, Equatable {
    let currency: CurrencyId
    let total: String
    let locked: String
    let available: String
}

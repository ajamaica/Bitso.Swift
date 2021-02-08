import Foundation

public struct BalanceCurrency: Decodable, Equatable {
    let currency: CurrencyId
    let amount: String
}

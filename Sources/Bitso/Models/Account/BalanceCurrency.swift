import Foundation

struct BalanceCurrency: Decodable, Equatable {
    let currency: CurrencyId
    let amount: String
}

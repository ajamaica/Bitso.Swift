import Foundation

public struct CustomerFees: Decodable, Equatable {
    let fees: [CustomerFee]
    let withdrawal_fees: [CurrencyId: String]
}

public struct CustomerFee: Decodable, Equatable {
    let book: BookSymbol
    let taker_fee_decimal: String
    let taker_fee_percent: String
    let maker_fee_decimal: String
    let maker_fee_percent: String
}

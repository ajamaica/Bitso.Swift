import Foundation

public struct OrderTrade: Decodable, Equatable {
    let book: BookSymbol
    let major: String
    let created_at: Date
    let minor: String
    let fees_amount: String
    let fees_currency: CurrencyId
    let price: String
    let tid: TradeID
    let oid: OrderId
    let origin_id: String?
    let side: Side
    let make_side: Side
}

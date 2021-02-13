import Foundation

public enum TradeStatus: String, Decodable {
    case queued
    case open
    case partialFill = "partial-fill"
}

public typealias OrderId = String
public struct Order: Decodable, Equatable {
        let book: BookSymbol
        let created_at: Date
        let oid: OrderId
        let original_amount: String
        let original_value: String
        let price: String
        let side: Side
        let status: TradeStatus
        let type: String
        let unfilled_amount: String
        let updated_at: Date
}

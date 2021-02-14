import Foundation

public enum TradeStatus: String, Decodable {
    case queued
    case open
    case partialFill = "partial-fill"
}

public enum OrderType: String, Decodable {
    case market
    case limit
}

public enum TimeInForce: String, Decodable {
    case goodtillcancelled
    case fillorkill
    case immediateorcancel
    case postonly
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
        let type: OrderType
        let unfilled_amount: String
        let updated_at: Date
}

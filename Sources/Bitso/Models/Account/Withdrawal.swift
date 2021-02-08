import Foundation

public enum WithdrawalStatus: String {
    case pending
    case processing
    case complete
    case failed
}
public typealias OriginID = String
typealias WithdrawalDetails = [String: String]
public typealias WithdrawalId = String
public struct Withdrawal {
    let wid: WithdrawalId
    let status: WithdrawalStatus
    let created_at: Date
    let currency: CurrencyId
    let method: String
    let amount: String
    let details: WithdrawalDetails
}

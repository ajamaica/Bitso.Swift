import Foundation

public enum WithdrawalStatus: String, Decodable {
    case pending
    case processing
    case complete
    case failed
}
public typealias OriginID = String
typealias WithdrawalDetails = DecodableDictionary
public typealias WithdrawalId = String
public struct Withdrawal: Decodable, Equatable {
    let wid: WithdrawalId
    let status: WithdrawalStatus
    let created_at: Date
    let currency: CurrencyId
    let method: String
    let amount: String
    let details: WithdrawalDetails?

    public static func == (lhs: Withdrawal, rhs: Withdrawal) -> Bool {
        return lhs.wid == rhs.wid
    }
}

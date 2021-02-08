import Foundation

public typealias OriginID = String
typealias WithdrawalDetails = DecodableDictionary
public typealias WithdrawalId = String
public struct Withdrawal: Decodable, Equatable {
    let wid: WithdrawalId
    let status: Status
    let created_at: Date
    let currency: CurrencyId
    let method: String
    let amount: String
    let details: WithdrawalDetails?

    public static func == (lhs: Withdrawal, rhs: Withdrawal) -> Bool {
        return lhs.wid == rhs.wid
    }
}

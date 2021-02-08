import Foundation

public struct Ledger: Decodable, Equatable {
    let eid: String
    let operation: String
    let created_at: Date
    let balance_updates: [BalanceCurrency]
    let details: LedgerDetails
}

public struct LedgerDetails: Decodable, Equatable {
    let tid: Int?
    let oid: String?
    let wid: WithdrawalId?
    let method: String?
}

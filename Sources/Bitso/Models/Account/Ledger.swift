import Foundation

struct Ledger: Decodable, Equatable {
    let eid: String
    let operation: String
    let created_at: Date
    let balance_updates: [BalanceCurrency]
    let details: LedgerDetails
}

struct LedgerDetails: Decodable, Equatable {
    let tid: Int?
    let oid: String?
    let wid: String?
    let method: String?
}

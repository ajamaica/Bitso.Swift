import Foundation

typealias LedgerDetails = DecodableDictionary
public struct Ledger: Decodable, Equatable {
    let eid: String
    let operation: String
    let created_at: Date
    let balance_updates: [BalanceCurrency]
    let details: LedgerDetails?

    public static func == (lhs: Ledger, rhs: Ledger) -> Bool {
        return lhs.eid == rhs.eid
    }
}

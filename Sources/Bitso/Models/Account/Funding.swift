import Foundation

typealias FundingDetails = DecodableDictionary
public struct Funding: Decodable, Equatable {
    let fid: String
    let status: Status
    let created_at: Date
    let currency: CurrencyId
    let method: String
    let amount: String
    let details: FundingDetails?

    public static func == (lhs: Funding, rhs: Funding) -> Bool {
        return lhs.fid == rhs.fid
    }
}

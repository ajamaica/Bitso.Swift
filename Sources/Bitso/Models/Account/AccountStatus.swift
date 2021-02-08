import Foundation

struct AccountStatus: Decodable, Equatable {
    let client_id: String
    let first_name: String
    let last_name: String
    let status: String
    let daily_limit: String
    let daily_remaining: String
    let monthly_limit: String
    let monthly_remaining: String
    let cash_deposit_allowance: String
    let cellphone_number: String
    let cellphone_number_stored: String
    let email_stored: String
    let official_id: String
    let proof_of_residency: String
    let signed_contract: String
    let origin_of_funds: String
}

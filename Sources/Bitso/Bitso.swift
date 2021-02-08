import Foundation

public typealias BitsoKey = Key
public typealias BitsoSecret = Secret

public class Bitso {
    private let environment: BitsoNetworkEnvironment
    private let router: Router<BitsoEndPoint>
    private let key: BitsoKey
    private let secret: BitsoSecret

    init(key: BitsoKey,
         secret: BitsoSecret,
         environment: BitsoNetworkEnvironment,
         router: Router<BitsoEndPoint> = Router<BitsoEndPoint>(session: URLSession.shared)
    ) {
        self.router = router
        self.environment = environment
        self.key = key
        self.secret = secret
    }

    /**
     This endpoint returns a list of existing exchange order books and their respective order placement limits.
     */
    func available_books(completion: @escaping (Result<[Book], BitsoError>) -> Void ) {
        request(apiCall: .available_books, completion: completion)
    }

    /**
     This endpoint returns trading information from the specified book.
     */
    func tickerFor(bookID: BookSymbol, completion: @escaping (Result<Ticker, BitsoError>) -> Void ) {
        request(apiCall: .ticker(bookID: bookID), completion: completion)
    }

    /**
     This endpoint returns a list of all open orders in the specified book. If the aggregate parameter is set to true,
     orders will be aggregated by price, and the response will only include the top 50 orders for each side of the book.
     If the aggregate parameter is set to false, the response will include the full order book.
     */
    func orderBookFor(bookID: BookSymbol, aggregate: Bool = true, completion: @escaping (Result<OrderBook, BitsoError>) -> Void ) {
        request(apiCall: .order_book(bookID: bookID, aggregate: aggregate), completion: completion)
    }

    /**
     This endpoint returns a list of recent trades from the specified book.
     */
    func tradesFor(bookID: BookSymbol,
                   marker: Bool?,
                   sort: SortType?,
                   limit: Int?,
                   completion: @escaping (Result<[Trade], BitsoError>) -> Void ) {
        request(apiCall: .trades(bookID: bookID, marker: marker, sort: sort, limit: limit), completion: completion)
    }

    /**
     This endpoint returns information concerning the user’s account status,
     documents uploaded, and transaction limits.
     */
    func accountStatus(completion: @escaping (Result<AccountStatus, BitsoError>) -> Void ) {
        request(apiCall: .account_status, completion: completion)
    }

    /**
     This endpoint is used to register Mobile phone number for verification.
     */
    func phoneNumber(phone_number: String, completion: @escaping (Result<Phone, BitsoError>) -> Void ) {
        request(apiCall: .phoneNumber(phone_number: phone_number), completion: completion)
    }

    /**
     This endpoint is used to verify a registered mobile phone number
     */
    func phoneVerification(verification_code: String, completion: @escaping (Result<Phone, BitsoError>) -> Void ) {
        request(apiCall: .phoneVerification(verification_code: verification_code), completion: completion)
    }

    /**
     This endpoint returns information concerning the user’s balances for all supported currencies.
     */
    func balance(completion: @escaping (Result<Balances, BitsoError>) -> Void ) {
        request(apiCall: .balance, completion: completion)
    }

    /**
     Returns a list of all the user’s registered operations.
     */
    func ledger(marker: Bool?,
                sort: SortType?,
                limit: Int?,
                completion: @escaping (Result<[Ledger], BitsoError>) -> Void ) {
        request(apiCall: .ledger(marker: marker, sort: sort, limit: limit), completion: completion)
    }

    /**
     Returns a list of all the user’s registered operations.
     */
    func ledgerTrades(marker: Bool?,
                      sort: SortType?,
                      limit: Int?,
                      completion: @escaping (Result<[Ledger], BitsoError>) -> Void ) {
        request(apiCall: .ledgerTrades(marker: marker, sort: sort, limit: limit), completion: completion)
    }

    /**
     Returns a list of all the user’s registered operations.
     */
    func ledgerFees(marker: Bool?,
                    sort: SortType?,
                    limit: Int?,
                    completion: @escaping (Result<[Ledger], BitsoError>) -> Void ) {
        request(apiCall: .ledgerFees(marker: marker, sort: sort, limit: limit), completion: completion)
    }

    /**
     Returns a list of all the user’s registered operations.
     */
    func ledgerFundings(marker: Bool?,
                        sort: SortType?,
                        limit: Int?,
                        completion: @escaping (Result<[Ledger], BitsoError>) -> Void ) {
        request(apiCall: .ledgerFundings(marker: marker, sort: sort, limit: limit), completion: completion)
    }

    /**
     Returns a list of all the user’s registered operations.
     */
    func ledgerWithdrawals(marker: Bool?,
                           sort: SortType?,
                           limit: Int?,
                           completion: @escaping (Result<[Ledger], BitsoError>) -> Void ) {
        request(apiCall: .ledgerWithdrawals(marker: marker, sort: sort, limit: limit), completion: completion)
    }

    /*
     This endpoint returns information on customer fees for all
     available order books, and withdrawal fees for applicable currencies.
     */
    func fees(completion: @escaping (Result<CustomerFees, BitsoError>) -> Void ) {
        request(apiCall: .fees, completion: completion)
    }

    /*
     Returns detailed info on a user’s fund withdrawals.
     */
    func withdrawals(wid: WithdrawalId,
                     marker: Bool?,
                     limit: Int?,
                     status: Status?,
                     method: String?,
                     completion: @escaping (Result<[Withdrawal], BitsoError>) -> Void ) {
        request(apiCall: .withdrawals(wid: wid,
                                      marker: marker,
                                      limit: limit,
                                      status: status,
                                      method: method),
                completion: completion)
    }

    /*
     Returns detailed info on a user’s fund withdrawals.
     */
    func withdrawalsForWid(wid: WithdrawalId,
                           marker: Bool?,
                           limit: Int?,
                           status: Status?,
                           method: String?,
                           completion: @escaping (Result<[Withdrawal], BitsoError>) -> Void ) {
        request(apiCall: .withdrawalsForWid(wid: wid,
                                            marker: marker,
                                            limit: limit,
                                            status: status,
                                            method: method),
                completion: completion)
    }

    /*
     Returns detailed info on a user’s fund withdrawals.
     */
    func withdrawalsForWids(wids: [WithdrawalId],
                            marker: Bool?,
                            limit: Int?,
                            status: Status?,
                            method: String?,
                            completion: @escaping (Result<[Withdrawal], BitsoError>) -> Void ) {
        request(apiCall: .withdrawalsForWids(wids: wids,
                                             marker: marker,
                                             limit: limit,
                                             status: status,
                                             method: method),
                completion: completion)
    }

    /*
     Returns detailed info on a user’s fund withdrawals.
     */
    func withdrawalsForOrigin(origin_ids: [OriginID],
                              marker: Bool?,
                              limit: Int?,
                              status: Status?,
                              method: String?,
                              completion: @escaping (Result<[Withdrawal], BitsoError>) -> Void ) {
        request(apiCall: .withdrawalsForOrigin(origin_ids: origin_ids,
                                               marker: marker,
                                               limit: limit,
                                               status: status,
                                               method: method),
                completion: completion)
    }

    func fundings(txids: [String]?,
                  completion: @escaping (Result<[Funding], BitsoError>) -> Void
    ) {
        request(apiCall: .fundings(marker: nil, limit: nil, status: nil, method: nil, txids: txids), completion: completion)
    }

    func fundings(marker: Bool?,
                  limit: Int?,
                  status: Status?,
                  method: String?,
                  completion: @escaping (Result<[Funding], BitsoError>) -> Void
    ) {
        request(apiCall: .fundings(marker: marker, limit: limit, status: status, method: method, txids: nil), completion: completion)
    }

    func fundingsTid(marker: Bool?,
                     limit: Int?,
                     status: Status?,
                     method: String?,
                     completion: @escaping (Result<[Funding], BitsoError>) -> Void
    ) {
        request(apiCall: .fundingsTid(marker: marker, limit: limit, status: status, method: method, txids: nil), completion: completion)
    }

    func fundingsTid(txids: [String]?,
                     completion: @escaping (Result<[Funding], BitsoError>) -> Void
    ) {
        request(apiCall: .fundingsTid(marker: nil, limit: nil, status: nil, method: nil, txids: txids), completion: completion)
    }

    func fundingsTidTidTid(marker: Bool?,
                           limit: Int?,
                           status: Status?,
                           method: String?,
                           completion: @escaping (Result<[Funding], BitsoError>) -> Void
    ) {
        request(apiCall: .fundingsTidTidTid(marker: marker, limit: limit, status: status, method: method, txids: nil), completion: completion)
    }

    func fundingsTidTidTid(txids: [String]?,
                           completion: @escaping (Result<[Funding], BitsoError>) -> Void
    ) {
        request(apiCall: .fundingsTidTidTid(marker: nil, limit: nil, status: nil, method: nil, txids: txids), completion: completion)
    }

    private func request<Payload: Decodable>(apiCall: BitsoAPICall,
                                             completion: @escaping (Result<Payload, BitsoError>) -> Void ) {
        router.request(.init(
                        enviroment: environment,
                        key: key,
                        secret: secret,
                        apiCall: apiCall)
        ) { ( data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(BitsoError.canNotReadError))
            }
            completion(handleNetworkResponse(response, data, error))
        }
    }

}

private func handleNetworkResponse<Payload: Decodable>(_ response: HTTPURLResponse,
                                                       _ data: Data?,
                                                       _ error: Error?) -> Result<Payload, BitsoError> {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom(BitsoDateDecodingStrategy.decode)
    if let error = error { return .failure(BitsoError(code: "-2", message: "Network error : \(error.localizedDescription)" )) }
    if let data =  data {
        do {
            let response = try decoder.decode(BitsoResponse<Payload>.self, from: data)
            if let payload = response.payload {
                return .success(payload)
            } else if let error = response.error {
                return .failure(error)
            }
        } catch let error {
            return .failure(BitsoError(code: "-3", message: "Can not decode json with error: \(error.localizedDescription)"))
        }
    }
    return .failure(BitsoError.canNotReadError)
}

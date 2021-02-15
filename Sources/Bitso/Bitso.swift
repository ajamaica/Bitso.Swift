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
    func ledger(marker: String?,
                sort: SortType?,
                limit: Int?,
                completion: @escaping (Result<[Ledger], BitsoError>) -> Void ) {
        request(apiCall: .ledger(marker: marker, sort: sort, limit: limit), completion: completion)
    }

    /**
     Returns a list of all the user’s registered operations.
     */
    func ledgerTrades(marker: String?,
                      sort: SortType?,
                      limit: Int?,
                      completion: @escaping (Result<[Ledger], BitsoError>) -> Void ) {
        request(apiCall: .ledgerTrades(marker: marker, sort: sort, limit: limit), completion: completion)
    }

    /**
     Returns a list of all the user’s registered operations.
     */
    func ledgerFees(marker: String?,
                    sort: SortType?,
                    limit: Int?,
                    completion: @escaping (Result<[Ledger], BitsoError>) -> Void ) {
        request(apiCall: .ledgerFees(marker: marker, sort: sort, limit: limit), completion: completion)
    }

    /**
     Returns a list of all the user’s registered operations.
     */
    func ledgerFundings(marker: String?,
                        sort: SortType?,
                        limit: Int?,
                        completion: @escaping (Result<[Ledger], BitsoError>) -> Void ) {
        request(apiCall: .ledgerFundings(marker: marker, sort: sort, limit: limit), completion: completion)
    }

    /**
     Returns a list of all the user’s registered operations.
     */
    func ledgerWithdrawals(marker: String?,
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
                     marker: String?,
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
                           marker: String?,
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
                            marker: String?,
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
                              marker: String?,
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
    /**
     Returns detailed info on a user’s fundings.
     */
    func fundings(txids: [String],
                  completion: @escaping (Result<[Funding], BitsoError>) -> Void
    ) {
        request(apiCall: .fundings(marker: nil, limit: nil, status: nil, method: nil, txids: txids), completion: completion)
    }
    /**
     Returns detailed info on a user’s fundings.
     */
    func fundings(marker: String?,
                  limit: Int?,
                  status: Status?,
                  method: String?,
                  completion: @escaping (Result<[Funding], BitsoError>) -> Void
    ) {
        request(apiCall: .fundings(marker: marker, limit: limit, status: status, method: method, txids: nil), completion: completion)
    }
    /**
     Returns detailed info on a user’s fundings.
     */
    func fundingsTid(marker: String?,
                     limit: Int?,
                     status: Status?,
                     method: String?,
                     completion: @escaping (Result<[Funding], BitsoError>) -> Void
    ) {
        request(apiCall: .fundingsTid(marker: marker, limit: limit, status: status, method: method, txids: nil), completion: completion)
    }
    /**
     Returns detailed info on a user’s fundings.
     */
    func fundingsTid(txids: [String],
                     completion: @escaping (Result<[Funding], BitsoError>) -> Void
    ) {
        request(apiCall: .fundingsTid(marker: nil, limit: nil, status: nil, method: nil, txids: txids), completion: completion)
    }
    /**
     Returns detailed info on a user’s fundings.
     */
    func fundingsTidTidTid(marker: String?,
                           limit: Int?,
                           status: Status?,
                           method: String?,
                           completion: @escaping (Result<[Funding], BitsoError>) -> Void
    ) {
        request(apiCall: .fundingsTidTidTid(marker: marker,
                                            limit: limit,
                                            status: status,
                                            method: method,
                                            txids: nil),
                completion: completion)
    }
    /**
     Returns detailed info on a user’s fundings.
     */
    func fundingsTidTidTid(txids: [String],
                           completion: @escaping (Result<[Funding], BitsoError>) -> Void
    ) {
        request(apiCall: .fundingsTidTidTid(marker: nil, limit: nil, status: nil, method: nil, txids: txids), completion: completion)
    }

    /**
     This endpoint returns a list of the user’s trades.
     */
    func userTrades(book: BookSymbol,
                    sort: SortType?,
                    limit: Int?,
                    marker: String?,
                    completion: @escaping (Result<[UserTrade], BitsoError>) -> Void
    ) {
        request(apiCall: .userTrades(book: book, sort: sort, limit: limit, marker: marker), completion: completion)
    }

    /**
     This endpoint returns a list of the user’s trades.
     */
    func userTradesTid(book: BookSymbol,
                       sort: SortType?,
                       limit: Int?,
                       marker: String?,
                       completion: @escaping (Result<[UserTrade], BitsoError>) -> Void
    ) {
        request(apiCall: .userTradesTid(book: book, sort: sort, limit: limit, marker: marker), completion: completion)
    }

    /**
     This endpoint returns a list of the user’s trades.
     */
    func userTradesTidTidTid(book: BookSymbol,
                             sort: SortType?,
                             limit: Int?,
                             marker: String?,
                             completion: @escaping (Result<[UserTrade], BitsoError>) -> Void
    ) {
        request(apiCall: .userTradesTidTidTid(book: book, sort: sort, limit: limit, marker: marker), completion: completion)
    }

    /**
     This endpoint returns a list of the user’s trades.
     */
    func orderTrades(oid: OrderId,
                     completion: @escaping (Result<[OrderTrade], BitsoError>) -> Void
    ) {
        request(apiCall: .orderTrades(oid: oid), completion: completion)
    }

    /**
     This endpoint returns a list of the user’s trades.
     */
    func orderTradesWithorigin(origin_id: String,
                               completion: @escaping (Result<[OrderTrade], BitsoError>) -> Void
    ) {
        request(apiCall: .orderTradesWithorigin(origin_id: origin_id), completion: completion)
    }

    /**
     Returns a list of the user’s open orders.
     */
    func openOrders(book: BookSymbol,
                    marker: String?,
                    sort: SortType?,
                    limit: Int?,
                    completion: @escaping (Result<[Order], BitsoError>) -> Void
    ) {
        request(apiCall: .openOrders(book: book, marker: marker, sort: sort, limit: limit), completion: completion)
    }

    /**
     Returns a list of details for 1 or more orders
     */
    func orders(oid: OrderId,
                completion: @escaping (Result<[Order], BitsoError>) -> Void
    ) {
        request(apiCall: .orders(oid: oid), completion: completion)
    }

    /**
     Returns a list of details for 1 or more orders
     */
    func ordersWithOids(oids: [OrderId],
                        completion: @escaping (Result<[Order], BitsoError>) -> Void
    ) {
        request(apiCall: .ordersWithOids(oids: oids), completion: completion)
    }

    /**
     Returns a list of details for 1 or more orders
     */
    func ordersWithOrigin(origin_ids: [OrderId],
                          completion: @escaping (Result<[Order], BitsoError>) -> Void
    ) {
        request(apiCall: .ordersWithOrigin(origin_ids: origin_ids), completion: completion)
    }

    /**
     Cancels open order(s)
     */
    func cancelOrder(oid: OrderId,
                     completion: @escaping (Result<[OrderId], BitsoError>) -> Void
    ) {
        request(apiCall: .cancelOrder(oid: oid), completion: completion)
    }
    /**
     Cancels open order(s)
     */
    func cancelOrderWithOids(oids: [OrderId],
                             completion: @escaping (Result<[OrderId], BitsoError>) -> Void
    ) {
        request(apiCall: .cancelOrderWithOids(oids: oids), completion: completion)
    }

    /**
     Cancels open order(s)
     */
    func cancelOrderWithOrigin(origin_ids: [String],
                               completion: @escaping (Result<[OrderId], BitsoError>) -> Void
    ) {
        request(apiCall: .cancelOrderWithOrigin(origin_ids: origin_ids), completion: completion)
    }

    /**
     Cancels open order(s)
     */
    func cancelAllOrders(completion: @escaping (Result<[OrderId], BitsoError>) -> Void
    ) {
        request(apiCall: .cancelAllOrders, completion: completion)
    }

    /*
     Places a buy or sell order (both limit and market orders are available)
     */
    func createOrder(book: BookSymbol,
                     side: Side,
                     amount: OrderAmount,
                     origin_id: String?,
                     time_in_force: TimeInForce?,
                     completion: @escaping (Result<PlacedOrder, BitsoError>) -> Void
    ) {
        request(apiCall: .createOrder(book: book, side: side, amount: amount, origin_id: origin_id, time_in_force: time_in_force), completion: completion)
    }

    /*
     Places a buy or sell order (both limit and market orders are available)
     */
    func createOrderLimit(book: BookSymbol,
                          side: Side,
                          amount: OrderAmount,
                          price: String,
                          stop: String,
                          time_in_force: TimeInForce?,
                          origin_id: String?,
                          completion: @escaping (Result<PlacedOrder, BitsoError>) -> Void
    ) {
        request(apiCall: .createOrderLimit(book: book,
                                           side: side,
                                           amount: amount,
                                           price: price,
                                           stop: stop,
                                           time_in_force: time_in_force,
                                           origin_id: origin_id), completion: completion)
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

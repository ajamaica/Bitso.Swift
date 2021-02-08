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

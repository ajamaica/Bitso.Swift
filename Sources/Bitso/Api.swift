import Foundation

public enum BitsoNetworkEnvironment: String {
    case productionV3 = "https://api.bitso.com/v3/"
    case developV3 = "https://api-dev.bitso.com/v3/"
}

extension BitsoNetworkEnvironment {
    func getEnviromentURL() -> URL {
        guard let url = URL(string: rawValue) else { fatalError("Invalid enviroment URL for \(self.rawValue)") }
        return url
    }
}

public enum SortType: String {
    case asc
    case desc
}

public enum BitsoAPICall {
    /* Private */
    case available_books
    case ticker(bookID: BookSymbol)
    case order_book(bookID: BookSymbol, aggregate: Bool?)
    case trades(bookID: BookSymbol, marker: Bool?, sort: SortType?, limit: Int?)
    /* Private */
    case account_status
    case phone_number(phone_number: String)
    case phone_verification(verification_code: String)
    case balance
    case fees

    case ledger(marker: Bool?, sort: SortType?, limit: Int?)
    case ledgerTrades(marker: Bool?, sort: SortType?, limit: Int?)
    case ledgerFees(marker: Bool?, sort: SortType?, limit: Int?)
    case ledgerFundings(marker: Bool?, sort: SortType?, limit: Int?)
    case ledgerWithdrawals(marker: Bool?, sort: SortType?, limit: Int?)

    case withdrawals(wid: WithdrawalId, marker: Bool?, limit: Int?, status: WithdrawalStatus?, method: String?)
    case withdrawalsForWid(wid: WithdrawalId, marker: Bool?, limit: Int?, status: WithdrawalStatus?, method: String?)
    case withdrawalsForWids(wids: [WithdrawalId], marker: Bool?, limit: Int?, status: WithdrawalStatus?, method: String?)
    case withdrawalsForOrigin(origin_ids: [OriginID], marker: Bool?, limit: Int?, status: WithdrawalStatus?, method: String?)
}

extension BitsoAPICall {
    func parameters() -> (bodyParameters: Parameters, urlParameters: Parameters) {
        var bodyParameters: Parameters = [:]
        var urlParameters: Parameters = [:]
        switch self {
        case .available_books: break
        case .ticker(bookID: let bookID):
            urlParameters.setParameter(key: "book", value: bookID)
        case .order_book(bookID: let bookID, aggregate: let aggregate):
            urlParameters.setParameter(key: "book", value: bookID)
            urlParameters.setParameter(key: "aggregate", value: aggregate)
        case .trades(bookID: let bookID, marker: let marker, sort: let sort, limit: let limit):
            urlParameters.setParameter(key: "book", value: bookID)
            urlParameters.setParameter(key: "marker", value: marker)
            urlParameters.setParameter(key: "sort", value: sort)
            urlParameters.setParameter(key: "limit", value: limit)
        case .account_status:
            break
        case .phone_number(let phone_number):
            bodyParameters.setParameter(key: "phone_number", value: phone_number)
        case .phone_verification(let verification_code):
            bodyParameters.setParameter(key: "verification_code", value: verification_code)
        case .balance: break
        case .fees: break
        case .ledger(let marker, let sort, let limit),
             .ledgerTrades(let marker, let sort, let limit),
             .ledgerFees(let marker, let sort, let limit),
             .ledgerFundings(let marker, let sort, let limit),
             .ledgerWithdrawals(let marker, let sort, let limit):
            urlParameters.setParameter(key: "marker", value: marker)
            urlParameters.setParameter(key: "sort", value: sort)
            urlParameters.setParameter(key: "limit", value: limit)
        case .withdrawals(let wid, let marker, let limit, let status, let method):
            urlParameters.setParameter(key: "marker", value: marker)
            urlParameters.setParameter(key: "wid", value: wid)
            urlParameters.setParameter(key: "limit", value: limit)
            urlParameters.setParameter(key: "status", value: status)
            urlParameters.setParameter(key: "method", value: method)
        case .withdrawalsForWid(let wid, let marker, let limit, let status, let method):
            urlParameters.setParameter(key: "marker", value: marker)
            urlParameters.setParameter(key: "wid", value: wid)
            urlParameters.setParameter(key: "limit", value: limit)
            urlParameters.setParameter(key: "status", value: status)
            urlParameters.setParameter(key: "method", value: method)
        case .withdrawalsForWids(let wids, let marker, let limit, let status, let method):
            urlParameters.setParameter(key: "marker", value: marker)
            urlParameters.setParameter(key: "wids", value: wids)
            urlParameters.setParameter(key: "limit", value: limit)
            urlParameters.setParameter(key: "status", value: status)
            urlParameters.setParameter(key: "method", value: method)
        case .withdrawalsForOrigin(let origin_ids, let marker, let limit, let status, let method):
            urlParameters.setParameter(key: "marker", value: marker)
            urlParameters.setParameter(key: "origin_ids", value: origin_ids)
            urlParameters.setParameter(key: "limit", value: limit)
            urlParameters.setParameter(key: "status", value: status)
            urlParameters.setParameter(key: "method", value: method)
        }
        return (bodyParameters, urlParameters)
    }
}

public struct BitsoEndPoint: EndPointType {
    private var bitsoKey: BitsoKey
    private var bitsoSecret: BitsoSecret
    private let enviroment: BitsoNetworkEnvironment
    private let apiCall: BitsoAPICall

    init(enviroment: BitsoNetworkEnvironment, key: BitsoKey, secret: BitsoSecret, apiCall: BitsoAPICall) {
        self.enviroment = enviroment
        self.apiCall = apiCall
        self.bitsoKey = key
        self.bitsoSecret = secret
    }
    var key: Key {
        return bitsoKey
    }
    var secret: BitsoKey {
        return bitsoSecret
    }
    var baseURL: URL {
        return enviroment.getEnviromentURL()
    }
    var task: HTTPTask {
        switch apiCall {
        case .available_books:
            return .request
        case .ticker:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: apiCall.parameters().urlParameters)
        case .order_book:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: apiCall.parameters().urlParameters)
        case .trades:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: apiCall.parameters().urlParameters)
        case .account_status:
            return .request
        case .phone_number:
            return .requestParameters(
                bodyParameters: apiCall.parameters().bodyParameters,
                bodyEncoding: .urlEncoding,
                urlParameters: nil)
        case .phone_verification:
            return .requestParameters(
                bodyParameters: apiCall.parameters().bodyParameters,
                bodyEncoding: .urlEncoding,
                urlParameters: nil)
        case .balance:
            return .request
        case .fees:
            return .request
        case .ledger, .ledgerTrades, .ledgerFees, .ledgerFundings, .ledgerWithdrawals:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: apiCall.parameters().urlParameters)
        case .withdrawals, .withdrawalsForWid, .withdrawalsForWids, .withdrawalsForOrigin:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: apiCall.parameters().urlParameters)
        }
    }

    var path: String {
        switch apiCall {
        case .available_books:
            return "available_books"
        case .ticker:
            return "ticker"
        case .order_book:
            return "order_book"
        case .trades:
            return "trades"
        case .account_status:
            return "account_status"
        case .phone_number:
            return "phone_number"
        case .phone_verification:
            return "phone_verification"
        case .balance:
            return "balance"
        case .fees:
            return "fees"
        case .ledger:
            return "ledger"
        case .ledgerTrades:
            return "ledger/trades"
        case .ledgerFees:
            return "ledger/fees"
        case .ledgerFundings:
            return "ledger/fundings"
        case .ledgerWithdrawals:
            return "ledger/withdrawals"
        case .withdrawals:
            return "withdrawals"
        case .withdrawalsForWid, .withdrawalsForWids, .withdrawalsForOrigin:
            return "withdrawals/wid"
        }
    }

    var httpMethod: HTTPMethod {
        switch apiCall {
        case .available_books:
            return .get
        case .ticker:
            return .get
        case .order_book:
            return .get
        case .trades:
            return .get
        case .account_status:
            return .get
        case .phone_number:
            return .post
        case .phone_verification:
            return .post
        case .balance:
            return .get
        case .fees:
            return .get
        case .ledger, .ledgerTrades, .ledgerFees, .ledgerFundings, .ledgerWithdrawals:
            return .get
        case .withdrawals, .withdrawalsForWid, .withdrawalsForWids, .withdrawalsForOrigin:
            return .get
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}

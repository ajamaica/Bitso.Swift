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

public enum OrderAmount {
    case major(amount: String)
    case minor(amount: String)
}

public enum BitsoAPICall {
    /* Private */
    case available_books
    case ticker(bookID: BookSymbol)
    case order_book(bookID: BookSymbol, aggregate: Bool?)
    case trades(bookID: BookSymbol, marker: Bool?, sort: SortType?, limit: Int?)
    /* Private */
    case account_status
    case phoneNumber(phone_number: String)
    case phoneVerification(verification_code: String)
    case balance
    case fees

    case ledger(marker: String?, sort: SortType?, limit: Int?)
    case ledgerTrades(marker: String?, sort: SortType?, limit: Int?)
    case ledgerFees(marker: String?, sort: SortType?, limit: Int?)
    case ledgerFundings(marker: String?, sort: SortType?, limit: Int?)
    case ledgerWithdrawals(marker: String?, sort: SortType?, limit: Int?)

    case withdrawals(wid: WithdrawalId, marker: String?, limit: Int?, status: Status?, method: String?)
    case withdrawalsForWid(wid: WithdrawalId, marker: String?, limit: Int?, status: Status?, method: String?)
    case withdrawalsForWids(wids: [WithdrawalId], marker: String?, limit: Int?, status: Status?, method: String?)
    case withdrawalsForOrigin(origin_ids: [OriginID], marker: String?, limit: Int?, status: Status?, method: String?)

    case fundings(marker: String?, limit: Int?, status: Status?, method: String?, txids: [String]?)
    case fundingsTid(marker: String?, limit: Int?, status: Status?, method: String?, txids: [String]?)
    case fundingsTidTidTid(marker: String?, limit: Int?, status: Status?, method: String?, txids: [String]?)

    case userTrades(book: BookSymbol, sort: SortType?, limit: Int?, marker: String?)
    case userTradesTid(book: BookSymbol, sort: SortType?, limit: Int?, marker: String?)
    case userTradesTidTidTid(book: BookSymbol, sort: SortType?, limit: Int?, marker: String?)
    case orderTrades(oid: OrderId)
    case orderTradesWithorigin(origin_id: String)

    case openOrders(book: BookSymbol, marker: String?, sort: SortType?, limit: Int?)

    case orders(oid: OrderId)
    case ordersWithOids(oids: [OrderId])
    case ordersWithOrigin(origin_ids: [String])

    case cancelOrder(oid: OrderId)
    case cancelOrderWithOids(oids: [OrderId])
    case cancelOrderWithOrigin(origin_ids: [String])
    case cancelAllOrders

    case createOrder(book: BookSymbol, side: Side, amount: OrderAmount, origin_id: String?, time_in_force: TimeInForce?)
    case createOrderLimit(book: BookSymbol, side: Side, amount: OrderAmount, price: String, stop: String, time_in_force: TimeInForce?, origin_id: String?)
}

extension BitsoAPICall {
    var bodyParameters: Parameters {
        var bodyParameters: Parameters = [:]
        switch self {
        case .account_status:
            break
        case .phoneNumber(let phone_number):
            bodyParameters.setParameter(key: "phone_number", value: phone_number)
        case .phoneVerification(let verification_code):
            bodyParameters.setParameter(key: "verification_code", value: verification_code)
        case .createOrder(let book, let side, let amount, let origin_id, let time_in_force):
            bodyParameters.setParameter(key: "book", value: book)
            bodyParameters.setParameter(key: "side", value: side)
            switch amount {
            case .major(let amount):
                bodyParameters.setParameter(key: "major", value: amount)
            case .minor(let amount):
                bodyParameters.setParameter(key: "major", value: amount)
            }
            bodyParameters.setParameter(key: "origin_id", value: origin_id)
            bodyParameters.setParameter(key: "time_in_force", value: time_in_force)
        case .createOrderLimit(let book, let side, let amount, let price, let stop, let time_in_force, let origin_id):
            bodyParameters.setParameter(key: "book", value: book)
            bodyParameters.setParameter(key: "side", value: side)
            switch amount {
            case .major(let amount):
                bodyParameters.setParameter(key: "major", value: amount)
            case .minor(let amount):
                bodyParameters.setParameter(key: "major", value: amount)
            }
            bodyParameters.setParameter(key: "price", value: price)
            bodyParameters.setParameter(key: "stop", value: stop)
            bodyParameters.setParameter(key: "origin_id", value: origin_id)
            bodyParameters.setParameter(key: "time_in_force", value: time_in_force)
        default: break
        }
        return bodyParameters
    }
    var urlParameters: Parameters {
        var urlParameters: Parameters = [:]
        switch self {
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
            urlParameters.setParameter(key: "wids", value: wids.joined(separator: ","))
            urlParameters.setParameter(key: "limit", value: limit)
            urlParameters.setParameter(key: "status", value: status)
            urlParameters.setParameter(key: "method", value: method)
        case .withdrawalsForOrigin(let origin_ids, let marker, let limit, let status, let method):
            urlParameters.setParameter(key: "marker", value: marker)
            urlParameters.setParameter(key: "origin_ids", value: origin_ids.joined(separator: ","))
            urlParameters.setParameter(key: "limit", value: limit)
            urlParameters.setParameter(key: "status", value: status)
            urlParameters.setParameter(key: "method", value: method)

        case .fundings(let marker, let limit, let status, let method, let txids),
             .fundingsTidTidTid(let marker, let limit, let status, let method, let txids),
             .fundingsTid(let marker, let limit, let status, let method, let txids):
                urlParameters.setParameter(key: "marker", value: marker)
                urlParameters.setParameter(key: "limit", value: limit)
                urlParameters.setParameter(key: "status", value: status)
                urlParameters.setParameter(key: "method", value: method)
                urlParameters.setParameter(key: "txids", value: txids?.joined(separator: ","))
        case .userTrades(let book, let sort, let limit, let marker),
             .userTradesTid(let book, let sort, let limit, let marker),
             .userTradesTidTidTid(let book, let sort, let limit, let marker):
            urlParameters.setParameter(key: "book", value: book)
            urlParameters.setParameter(key: "sort", value: sort)
            urlParameters.setParameter(key: "limit", value: limit)
            urlParameters.setParameter(key: "marker", value: marker)
        case .orderTradesWithorigin(let origin_id):
            urlParameters.setParameter(key: "origin_id", value: origin_id)
        case .openOrders(let book, let marker, let sort, let limit):
            urlParameters.setParameter(key: "book", value: book)
            urlParameters.setParameter(key: "marker", value: marker)
            urlParameters.setParameter(key: "limit", value: limit)
            urlParameters.setParameter(key: "sort", value: sort)
        case .orders(let oid):
            urlParameters.setParameter(key: "oid", value: oid)
        case .ordersWithOids(let oids):
            urlParameters.setParameter(key: "oids", value: oids.joined(separator: ","))
        case .ordersWithOrigin(let origin_ids):
            urlParameters.setParameter(key: "origin_ids", value: origin_ids)
        case .cancelOrder(let oid):
            urlParameters.setParameter(key: "oid", value: oid)
        case .cancelOrderWithOids(let oids):
            urlParameters.setParameter(key: "oids", value: oids)
        case .cancelOrderWithOrigin(let origin_ids):
            urlParameters.setParameter(key: "origin_ids", value: origin_ids)
        default: break
        }
        return urlParameters
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
    public var key: Key {
        return bitsoKey
    }
    public var secret: BitsoKey {
        return bitsoSecret
    }
    public var baseURL: URL {
        return enviroment.getEnviromentURL()
    }
    public var task: HTTPTask {
        switch apiCall {
        case .available_books:
            return .request
        case .ticker:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: apiCall.urlParameters)
        case .order_book:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: apiCall.urlParameters)
        case .trades:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: apiCall.urlParameters)
        case .account_status:
            return .request
        case .phoneNumber:
            return .requestParameters(
                bodyParameters: apiCall.bodyParameters,
                bodyEncoding: .urlEncoding,
                urlParameters: nil)
        case .phoneVerification:
            return .requestParameters(
                bodyParameters: apiCall.bodyParameters,
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
                urlParameters: apiCall.urlParameters)
        case .withdrawals, .withdrawalsForWid, .withdrawalsForWids, .withdrawalsForOrigin:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: apiCall.urlParameters)
        case .fundings, .fundingsTid, .fundingsTidTidTid:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: apiCall.urlParameters)
        case .userTrades, .userTradesTid, .userTradesTidTidTid:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: apiCall.urlParameters)
        case .orderTrades:
            return .request
        case .orderTradesWithorigin:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: apiCall.urlParameters)
        case .openOrders:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: apiCall.urlParameters)
        case .orders, .ordersWithOids, .ordersWithOrigin:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: apiCall.urlParameters)
        case .cancelOrder, .cancelOrderWithOids, .cancelOrderWithOrigin, .cancelAllOrders:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: apiCall.urlParameters)
        case .createOrder, .createOrderLimit:
            return .requestParameters(
                bodyParameters: apiCall.bodyParameters,
                bodyEncoding: .urlEncoding,
                urlParameters: nil)
        }
    }

    public var path: String {
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
        case .phoneNumber:
            return "phone_number"
        case .phoneVerification:
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
        case .withdrawals, .withdrawalsForWids, .withdrawalsForOrigin:
            return "withdrawals"
        case .withdrawalsForWid:
            return "withdrawals/wid"
        case .fundings:
            return "fundings"
        case .fundingsTid:
            return "fundings/fid"
        case .fundingsTidTidTid:
            return "fundings/fid-fid-fid"
        case .userTrades:
            return "user_trades"
        case .userTradesTid:
            return "user_trades/tid"
        case .userTradesTidTidTid:
            return "user_trades/tid-tid-tid"
        case .orderTrades(let oid):
            return "order_trades/\(oid)"
        case .orderTradesWithorigin:
            return "order_trades"
        case .openOrders:
            return "open_orders"
        case .orders, .ordersWithOids, .ordersWithOrigin,
             .cancelOrder, .cancelOrderWithOids, .cancelOrderWithOrigin:
            return "orders"
        case .cancelAllOrders:
            return "orders/all"
        case .createOrder, .createOrderLimit:
            return "orders"
        }
    }

    public var httpMethod: HTTPMethod {
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
        case .phoneNumber:
            return .post
        case .phoneVerification:
            return .post
        case .balance:
            return .get
        case .fees:
            return .get
        case .ledger, .ledgerTrades, .ledgerFees, .ledgerFundings, .ledgerWithdrawals:
            return .get
        case .withdrawals, .withdrawalsForWid, .withdrawalsForWids, .withdrawalsForOrigin:
            return .get
        case .fundings, .fundingsTid, .fundingsTidTidTid:
            return .get
        case .userTrades, .userTradesTid, .userTradesTidTidTid:
            return .get
        case .orderTrades:
            return .get
        case .orderTradesWithorigin:
            return .get
        case .openOrders:
            return .get
        case .orders, .ordersWithOids, .ordersWithOrigin:
            return .get
        case .cancelOrder, .cancelOrderWithOids, .cancelOrderWithOrigin, .cancelAllOrders:
            return .delete
        case .createOrder, .createOrderLimit:
            return .post
        }
    }

    public var headers: HTTPHeaders? {
        return nil
    }
}

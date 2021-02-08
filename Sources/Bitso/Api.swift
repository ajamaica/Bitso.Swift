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
}

extension BitsoAPICall {
    func parameters() -> (bodyParameters: Parameters, urlParameters: Parameters) {
        var bodyParameters: Parameters = [:]
        var urlParameters: Parameters = [:]
        switch self {
        case .available_books:
            break
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
        case .phone_number(phone_number: let phone_number):
            bodyParameters.setParameter(key: phone_number, value: phone_number)
        case .phone_verification(verification_code: let verification_code):
            bodyParameters.setParameter(key: verification_code, value: verification_code)
        case .balance:
            break
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
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}

import Foundation

public enum BitsoNetworkEnvironment: String {
    case productionV3 = "https://api-dev.bitso.com/v3/"
    case developV3 = "https://api.bitso.com/v3/"
}

extension BitsoNetworkEnvironment {
    func getEnviromentURL() -> URL {
        guard let url = URL(string: rawValue) else { fatalError("Invalid enviroment URL for \(self.rawValue)") }
        return url
    }
}

public enum BitsoAPICall {
   case available_books
}

public struct BitsoEndPoint: EndPointType {
    private let enviroment: BitsoNetworkEnvironment
    private let apiCall: BitsoAPICall
    init(enviroment: BitsoNetworkEnvironment, apiCall: BitsoAPICall) {
        self.enviroment = enviroment
        self.apiCall = apiCall
    }
    var baseURL: URL {
        return enviroment.getEnviromentURL()
    }
    var task: HTTPTask {
        return .request
    }
    var path: String {
        switch apiCall {
        case .available_books:
            return "available_books"
        }
    }
    var httpMethod: HTTPMethod {
        return .get
    }
    var headers: HTTPHeaders? {
        return nil
    }
}

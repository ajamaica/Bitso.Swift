//
//  Router.swift
//  Arturo Jamaica
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation

// Simplify network response block
public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    // Urlsession task reference
    private var task: URLSessionTask?
    private let session: URLSession
    private let enableDebugLogs: Bool

    // By using a default argument (in this case .shared) we can add dependency
    init(session: URLSession = .shared, enableDebugLogs: Bool = false) {
        self.session = session
        self.enableDebugLogs = enableDebugLogs
    }

    /**
     Execute a Network request using a given endpoints and waits when complete
     - parameters:
     - route: The potential URL request. Reference Parameter
     - completion : Reference to block for excecution after load or fail
     */
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {

        do {
            let request = try self.buildRequest(from: route)
            if enableDebugLogs { NetworkLogger.log(request: request) }
            task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
                if let response = response, self?.enableDebugLogs == true { NetworkLogger.log(response: response, data: data)  }
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }

    /**
     Cancels the current request.
    */
    func cancel() {
        self.task?.cancel()
    }

    /**
     Construct a URLRequest Ubject with the given EndPoint
     - parameters:
     - route: target Route endpoint
     */
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {

        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)

        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):

                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }

            // Inject the Bitso Authorization Header = Authorization: Authorization Header <key>:<nonce>:<signature>
            let signingHeader = bitsoSigning(key: route.key,
                                             secret: route.secret,
                                             httpMethod: route.httpMethod,
                                             requestPath: route.path,
                                             parameters: request.httpBody)
            self.addAdditionalHeaders(signingHeader, request: &request)
            return request
        } catch {
            throw error
        }
    }

    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }

    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }

}

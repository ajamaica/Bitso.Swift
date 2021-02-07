//
//  NetworkLogger.swift
//  Arturo Jamaica
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation

class NetworkLogger {

    /**
     Logs a Network request at the console for easier debugging.
     Adds template for request
     - parameters:
        - request: Describe the request for the network
    */
    static func log(request: URLRequest) {

        debugPrint("\n - - - - - - - - - - Start  Request - - - - - - - - - - \n")

        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)

        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"

        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }

        debugPrint(logOutput)
        debugPrint("\n - - - - - - - - - -  END Request- - - - - - - - - - \n")
    }

    /**
     Logs a Network response at the console for easier debugging.
     Adds template for response
     - parameters:
        - response: Describe the response for the network
     */
    static func log(response: URLResponse) {
        debugPrint("\n - - - - - - - - - - Start  Response - - - - - - - - - - \n")

        let urlAsString = response.url?.absoluteString ?? ""

        let mimeType = response.mimeType != nil ? "\(response.mimeType ?? "")" : ""

        var logOutput = """
        \(urlAsString) \n\n
        \(mimeType) \n
        """

        if let response = response as? HTTPURLResponse {
            logOutput += "statusCode: \(response.statusCode) \n"
        }

        debugPrint(logOutput)
        debugPrint("\n - - - - - - - - - -  END Response- - - - - - - - - - \n")

    }
}

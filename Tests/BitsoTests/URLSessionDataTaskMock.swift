//
//  URLSessionDataTaskMock.swift
//  Bitso.SwiftTests
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}

class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    var data: Data?
    var error: Error?
    
    override func dataTask(with request: URLRequest,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        
        return URLSessionDataTaskMock {
            completionHandler(data,
                              HTTPURLResponse(
                                url: URL(string: "http://localhost.com")!,
                                statusCode: 200,
                                httpVersion: nil,
                                headerFields: nil),
                              error)
        }
    }
}

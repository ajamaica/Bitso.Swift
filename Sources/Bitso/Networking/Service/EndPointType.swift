//
//  EndPointType.swift
//  Arturo Jamaica
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation

// Target endpoint with Parameters, BaseURL, Headers and Paths
// This is the representation of the network url request.
// It is a protocol so we can be ensure all endpoint comply with everthing
// It also allows reuse for diferent Endpoint on the app
public typealias Key = String
public typealias Secret = String
protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    var key: Key { get }
    var secret: Secret { get }
}

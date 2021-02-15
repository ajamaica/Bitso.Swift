//
//  HTTPTask.swift
//  Arturo Jamaica
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation

// HTTP Header Abstation
public typealias HTTPHeaders = [String: String]

// Allows normal call or with Headers or with Parameters
public enum HTTPTask {
    case request

    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)

    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
}

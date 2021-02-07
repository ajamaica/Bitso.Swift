//
//  NetworkResponseType.swift
//  Arturo Jamaica
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation

enum NetworkResponseError: String, Error {
    case authenticationError = "Please login First."
    case badRequest = "Bad Request"
    case outdated = "Outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data."
    case unableToDecode = "We could not parse the response."
}

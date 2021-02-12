//
//  SignatureTests.swift
//  
//
//  Created by Arturo Jamaica on 2021/02/07.
//
import XCTest
@testable import Bitso

class SignatureTests: XCTestCase {

    func test_hmac() {
        let expectedValue = "04fe927d5a3bbba18bd9858c03ea7d2edd85f3e322b698caa23785ec9f4cfb8e"
        let input = "ABCDEFG"
        let secret = "SECRET"
        let output = input.hmac_256(key: secret)
        XCTAssertEqual(expectedValue, output)
    }

    func test_signature_header() {
        let expectedResult = "Bitso BITSO_KEY:1613103285919:0e6c098248fb6a0c4a978dd71e38f0be579c7f958c577e1b45a3d23cc67a5eaa"
        let key = "BITSO_KEY"
        let secret = "BITSO_SECRET"
        let httpMethod = HTTPMethod.post.rawValue
        let requestPath = "/v3/balance/"

        var jsonPayload = Parameters()
        jsonPayload.setParameter(key: "key", value: "value")
        var jsonString = ""
        if !jsonPayload.keys.isEmpty {
            let jsonAsData = try! JSONSerialization.data(withJSONObject: jsonPayload, options: [.sortedKeys])
            jsonString = String(data: jsonAsData, encoding: .utf8)!.replaceColon()
        }

        let nonce = "1613103285919"
        let message = "\(nonce)\(httpMethod)\(requestPath)\(jsonString)"
        let signature = message.hmac_256(key: secret)
        let auth_header = "Bitso \(key):\(nonce):\(signature)"
        XCTAssertEqual(expectedResult, auth_header)
    }

    func test_signature_header_no_payload() {
        let expectedResult = "Bitso BITSO_KEY:1613101572573:d41ffae5c1e6d077cec86ea9397f6550889b174847aa6965d6384b661bbeb017"
        let key = "BITSO_KEY"
        let secret = "BITSO_SECRET"
        let httpMethod = HTTPMethod.get.rawValue
        let requestPath = "/v3/balance/"

        let nonce = "1613101572573"
        let message = "\(nonce)\(httpMethod)\(requestPath)"
        let signature = message.hmac_256(key: secret)
        let auth_header = "Bitso \(key):\(nonce):\(signature)"
        XCTAssertEqual(expectedResult, auth_header)
    }

    func test_signature_header2() {
        let expectedResult = ["Authorization": "Bitso BITSO_KEY:1613103285919:0e6c098248fb6a0c4a978dd71e38f0be579c7f958c577e1b45a3d23cc67a5eaa"]
        let key = "BITSO_KEY"
        let secret = "BITSO_SECRET"
        let httpMethod = HTTPMethod.post
        let requestPath = "/v3/balance/"
        var jsonPayload = Parameters()
        jsonPayload.setParameter(key: "key", value: "value")
        let jsonAsData = try! JSONSerialization.data(withJSONObject: jsonPayload, options: .sortedKeys)
        let auth_header = bitsoSigning(key: key,
                                       secret: secret,
                                       httpMethod: httpMethod,
                                       requestPath: requestPath,
                                       parameters: jsonAsData,
                                       nonce: "1613103285919")
        XCTAssertEqual(expectedResult, auth_header)
    }
}


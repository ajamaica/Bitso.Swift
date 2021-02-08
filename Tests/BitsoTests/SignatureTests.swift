//
//  SignatureTests.swift
//  
//
//  Created by Arturo Jamaica on 2021/02/07.
//
import XCTest
@testable import Bitso

class SignatureTests: XCTestCase {
    
    func test_hmac(){
        let expectedValue = "04fe927d5a3bbba18bd9858c03ea7d2edd85f3e322b698caa23785ec9f4cfb8e"
        let input = "ABCDEFG"
        let secret = "SECRET"
        let output = input.hmac_256(key: secret)
        XCTAssertEqual(expectedValue, output)
    }
    
    func test_signature_header() {
        let expectedResult = "Bitso BITSO_KEY:1612699412:c9f81ad14895f7b290ccdae5a8dc2d6471f9eec117485345b70e34fe93c3b30f"
        let key = "BITSO_KEY"
        let secret = "BITSO_SECRET"
        let httpMethod = HTTPMethod.get.rawValue
        let requestPath = "/v3/balance/"
        
        var jsonPayload = Parameters()
        jsonPayload.setParameter(key: "key", value: "value")
        var jsonString = ""
        if !jsonPayload.keys.isEmpty {
            let jsonAsData = try! JSONSerialization.data(withJSONObject: jsonPayload, options: .sortedKeys)
            jsonString = String(data: jsonAsData, encoding: .utf8)!
        }

        let nonce = "1612699412"
        let message = "\(nonce)\(httpMethod)\(requestPath)\(jsonString)"
        let signature = message.hmac_256(key: secret)
        let auth_header = "Bitso \(key):\(nonce):\(signature)"
        XCTAssertEqual(expectedResult, auth_header)
    }
    
    func test_signature_header_no_payload() {
        let expectedResult = "Bitso BITSO_KEY:1612699412:6fc902116c72596a28c9887f7fbacace307b1f77e244262c2cd7179885f50b40"
        let key = "BITSO_KEY"
        let secret = "BITSO_SECRET"
        let httpMethod = HTTPMethod.get.rawValue
        let requestPath = "/v3/balance/"
        
        let nonce = "1612699412"
        let message = "\(nonce)\(httpMethod)\(requestPath)"
        let signature = message.hmac_256(key: secret)
        let auth_header = "Bitso \(key):\(nonce):\(signature)"
        XCTAssertEqual(expectedResult, auth_header)
    }
    
    func test_signature_header2() {
        let expectedResult = "Bitso BITSO_KEY:1612699412:c9f81ad14895f7b290ccdae5a8dc2d6471f9eec117485345b70e34fe93c3b30f"
        let key = "BITSO_KEY"
        let secret = "BITSO_SECRET"
        let httpMethod = HTTPMethod.get
        let requestPath = "/v3/balance/"
        var jsonPayload = Parameters()
        jsonPayload.setParameter(key: "key", value: "value")
        
        let auth_header = signing(key: key, secret: secret, httpMethod: httpMethod, requestPath: requestPath, parameters: jsonPayload)
        XCTAssertEqual(expectedResult, auth_header)
    }
}



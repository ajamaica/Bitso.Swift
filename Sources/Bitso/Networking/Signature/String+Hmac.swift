//
//  File.swift
//  
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation
import CommonCrypto

func signing(key: String, secret: String, httpMethod: HTTPMethod, requestPath: String, parameters: Parameters) -> String {
    var jsonString = ""
    if !parameters.keys.isEmpty, let jsonAsData = try? JSONSerialization.data(withJSONObject: parameters, options: .sortedKeys) {
        jsonString = String(data: jsonAsData, encoding: .utf8)!
    }
    let nonce = "1612699412"
    let message = "\(nonce)\(httpMethod.rawValue)\(requestPath)\(jsonString)"
    let signature = message.hmac_256(key: secret)
    let auth_header = "Bitso \(key):\(nonce):\(signature)"
    return auth_header
}

public extension String {
    func hmac_256(key: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key, key.count, self, self.count, &digest)
        let data = Data(digest)
        return data.map { String(format: "%02hhx", $0) }.joined()
    }
}

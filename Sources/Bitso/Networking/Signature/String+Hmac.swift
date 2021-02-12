//
//  File.swift
//  
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation
import CommonCrypto

/**
 *  Creates a custom signing header for bitso using a HMAC with SHA256. The signature is generated
 *   by creating a SHA256 HMAC using the Bitso API Secret on the concatenation of nonce + HTTP method
 *   + requestPath + JSON payload (no ’+’ signs in the concatenated string) and hex encode the output.
 *   The nonce value should be the same as the nonce field in the Authorization header. The requestPath
 *   and JSON payload must, of course, be exactly as the ones used in the request.
 */
func bitsoSigning(key: BitsoKey,
                  secret: BitsoSecret,
                  httpMethod: HTTPMethod,
                  requestPath: String,
                  parameters: Data?,
                  nonce: String
) -> HTTPHeaders {
    var jsonString = ""
    if httpMethod == .post,
        let parameters = parameters {
        jsonString = String(data: parameters, encoding: .utf8)!.replaceColon()
    }
    let nonce = nonce
    let message = "\(nonce)\(httpMethod.rawValue)\(requestPath)\(jsonString)"
    let signature = message.hmac_256(key: secret)
    let auth_header = "Bitso \(key):\(nonce):\(signature)"
    return ["Authorization": auth_header]
}

public extension String {
    func hmac_256(key: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key, key.count, self, self.count, &digest)
        let data = Data(digest)
        return data.map { String(format: "%02hhx", $0) }.joined()
    }
}

public extension String {
   func replace(string: String, replacement: String) -> String {
       return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
   }

   func replaceColon() -> String {
       return self.replace(string: ":", replacement: ": ")
   }
 }

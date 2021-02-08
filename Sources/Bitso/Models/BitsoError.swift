import Foundation

public struct BitsoError: Error, Decodable, Equatable {
    static let canNotReadError = BitsoError(code: "-1", message: "Unkown Error code from bitso")
    let code: String
    let message: String
}

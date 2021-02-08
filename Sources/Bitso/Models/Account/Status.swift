import Foundation

public enum Status: String, Decodable {
    case pending
    case processing
    case complete
    case failed
}

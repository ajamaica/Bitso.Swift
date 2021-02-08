import Foundation

public struct BitsoResponse<Payload: Decodable>: Decodable {
    let success: Bool
    let payload: Payload?
    let error: BitsoError?
}

//
//  File.swift
//  
//
//  Created by Arturo Jamaica on 2021/02/07.
//

import Foundation
/*
    Bitso has 2 types of ISO8601 some calls the use with factions others without.
*/
enum BitsoDateDecodingStrategy {

    private static let formatterWithSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withTimeZone,
            .withFractionalSeconds
        ]
        return formatter
    }()

    private static let formatterWithNoSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withTimeZone
        ]
        return formatter
    }()

    static func decode(_ decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateStr = try container.decode(String.self)
        if let date = formatterWithSeconds.date(from: dateStr) {
            return date
        }

        if let date = formatterWithNoSeconds.date(from: dateStr) {
            return date
        } else {
            throw NSError(domain: "date", code: -10, userInfo: nil)
        }
    }
}

//
//  String+Extension.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 11.10.2023.
//

import Foundation

extension String {
    func formattedFromISO8601() -> String {
        let dateFormatterFromISO8601 = DateFormatter()
        dateFormatterFromISO8601.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatterFromISO8601.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterFromISO8601.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatterFromISO8601.date(from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy, h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date ?? Date())
    }
    
    var countryName: String {
        Locale(identifier: "en_US").localizedString(forRegionCode: self) ?? "--"
    }
}

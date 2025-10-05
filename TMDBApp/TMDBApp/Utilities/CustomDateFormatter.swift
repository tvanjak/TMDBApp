//
//  DateFormatter.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 21.09.2025..
//

import SwiftUI

class CustomDateFormatter {
    private static let yyyyMMddFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    private static let yyyyFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy"
        return df
    }()
    
    private static let ddMMyyyyFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        return df
    }()
    
    
    static func fromYYYYMMdd(_ dateString: String) -> Date? {
        return yyyyMMddFormatter.date(from: dateString)
    }
    
    static func toYYYY(_ date: Date) -> String {
        return yyyyFormatter.string(from: date)
    }
    
    static func toDDMMYYYY(_ date: Date) -> String {
        return ddMMyyyyFormatter.string(from: date)
    }
    
    static func getCurrentDate() -> String {
        return toDDMMYYYY(Date())
    }
}


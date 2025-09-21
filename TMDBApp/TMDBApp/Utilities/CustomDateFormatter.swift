//
//  DateFormatter.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 21.09.2025..
//

import SwiftUI

class CustomDateFormatter {
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: Date())
        return dateString
    }
}

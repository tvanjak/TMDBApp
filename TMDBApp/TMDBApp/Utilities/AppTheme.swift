//
//  AppTheme.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 26.08.2025..
//

import Foundation
import SwiftUI

struct AppTheme {
    
    struct Colors {
        static let background = Color(red: 11/255, green: 37/255, blue: 63/255)
        static let lightBlue = Color(red: 76/255, green: 178/255, blue: 223/255)
        static let darkBlue = Color(red: 21/255, green: 77/255, blue: 133/255)
        static let lightGreen = Color(red: 154/255, green: 203/255, blue: 165/255)
        static let textPrimary = Color.white
        static let textSecondary = Color.secondary
    }
    
    struct Typography {
        static let largeTitle = Font.largeTitle
        static let title = Font.title
        static let title2 = Font.title2
        
//        static let title4 = Font.system(size: 14, weight: .bold, design: .default)
        static let subtitle = Font.system(size: 22, weight: .regular, design: .default)
        static let body = Font.system(size: 18, weight: .regular, design: .default)
//        static let caption = Font.system(size: 12, weight: .light)
    }
    
    struct Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }
    
    struct Radius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 20
    }
}

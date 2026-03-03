//
//  AppStyle.swift
//  exchange
//
//  Created by Nikolai on 02/03/2026.
//

import UIKit

enum AppStyle {
    
    // MARK: - Color
    
    enum Color {
        // Background
        static let backgroundPrimary = UIColor(resource: .backgroundPrimary)
        static let backgroundSecondary = UIColor(resource: .backgroundSecondary)
        
        // Text
        static let textPrimary = UIColor(resource: .textPrimary)
        
        // Accent
        static let accent = UIColor(resource: .accent)
    }
    
    // MARK: - Typography
    
    enum Typography {
        
        /// Dynamic Type: Size: 30, Weight: .bold
        static func header() -> UIFont {
            customFont(size: 30, weight: .bold, textStyle: .largeTitle)
        }
        
        /// Dynamic Type: Size: 24, Weight: .regular
        static func title() -> UIFont {
            customFont(size: 24, weight: .regular, textStyle: .title1)
        }
        
        /// Dynamic Type: Size: 16, Weight: .semibold
        static func body() -> UIFont {
            customFont(size: 16, weight: .semibold, textStyle: .body)
        }
        
        // Dynamic Type
        private static func customFont(size: CGFloat, weight: UIFont.Weight, textStyle: UIFont.TextStyle) -> UIFont {
            
            let font = UIFont.systemFont(ofSize: size, weight: weight)

            return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
        }
    }
}

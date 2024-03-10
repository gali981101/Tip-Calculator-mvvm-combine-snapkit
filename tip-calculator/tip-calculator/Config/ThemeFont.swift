//
//  ThemeFont.swift
//  tip-calculator
//
//  Created by Terry Jason on 2024/3/6.
//

import UIKit

struct ThemeFont {}

// MARK: - Bodoni 72

extension ThemeFont {
    
    static func book(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Bodoni 72 Book", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bookItalic(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Bodoni 72 Book Italic", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func bold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Bodoni 72 Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func oldStyleBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Bodoni 72 Oldstyle Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func oldStyleBook(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Bodoni 72 Oldstyle Book", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func oldStyleBookItalic(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Bodoni 72 Oldstyle Book Italic", size: size) ?? .systemFont(ofSize: size)
    }
    
}

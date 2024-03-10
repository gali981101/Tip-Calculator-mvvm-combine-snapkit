//
//  Double+Extension.swift
//  tip-calculator
//
//  Created by Terry Jason on 2024/3/8.
//

import Foundation

extension Double {
    
    var currencyFormatted: String {
        
        var isWholeNumber: Bool {
            isZero ? true : !isNormal ? false : self == rounded()
        }
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = isWholeNumber ? 0 : 2
        formatter.currencySymbol = "$"
        
        return formatter.string(for: self) ?? ""
    }
    
}

//
//  Extensions.swift
//  SpareParts
//
//  Created by Anas Bashandy on 17/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import Foundation

extension Double {
    static let currencyEgyptian: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EGP"
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var convertToEgyptianCurrency: String {
        return Double.currencyEgyptian.string(for: self) ?? ""
    }
    
    static let currencyJapan: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "JPY"
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var convertToJapaneseCurrency: String {
        return Double.currencyJapan.string(for: self) ?? ""
    }
    
    static let clean: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 4
        return formatter
    }()
    var cleaned: String {
        return Double.clean.string(for: self) ?? ""
    }
}


extension FloatingPoint {
    func rounded(to n: Int) -> Self {
        let n = Self(n)
        return (self / n).rounded() * n
    }
}


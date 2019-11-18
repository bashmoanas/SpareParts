//
//  Payment.swift
//  SpareParts
//
//  Created by Anas Bashandy on 12/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import Foundation

struct Payment: Comparable, Codable {
    var amount: Double
    var date: Date
    var collectedBy: Employee
    var notes: String?
    
    static let paymentDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static func <(lhs: Payment, rhs: Payment) -> Bool {
        return lhs.date < rhs.date
    }
}

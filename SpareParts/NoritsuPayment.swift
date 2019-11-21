//
//  NoritsuPayment.swift
//  SpareParts
//
//  Created by Anas Bashandy on 20/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import Foundation

struct NoritsuPayment: Comparable, Codable {
    var amount: Double
    var date: Date
    
    static let paymentDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static func <(lhs: NoritsuPayment, rhs: NoritsuPayment) -> Bool {
        return lhs.date < rhs.date
    }
    
    static var allPaymentsTotal: Double? {
        var total = 0.0
        
        guard let allPayments = NoritsuPayment.all else { return nil}
        
        for payment in allPayments {
            let amount = payment.amount
            total += amount
        }
        
        return total
    }
    
    static var currentNoritsuBalance: Double? {
        guard let allPaymentsTotal = allPaymentsTotal,
            let allPurchasesTotal = PurchaseOrder.allPurchasesTotal else { return nil }
        return allPaymentsTotal - allPurchasesTotal
    }
    
    static var ArchiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("noritsuPayments").appendingPathExtension("plist")
    
    static func save(noritsuPayments: [NoritsuPayment]) {
        let propertyListEncoder = PropertyListEncoder()
        let saveNoritsuPayments = try? propertyListEncoder.encode(noritsuPayments)
        try? saveNoritsuPayments?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadNoritsuPayments() -> [NoritsuPayment]? {
        guard let savedNoritsuPayments = try? Data(contentsOf: ArchiveURL) else { return nil}
        let propertyListDecoder = PropertyListDecoder()
        
        return try? propertyListDecoder.decode([NoritsuPayment].self, from: savedNoritsuPayments)
    }
    
    static var all: [NoritsuPayment]? {
        return loadNoritsuPayments()
    }
}

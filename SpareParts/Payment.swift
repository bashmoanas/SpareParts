//
//  Payment.swift
//  SpareParts
//
//  Created by Anas Bashandy on 12/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import Foundation

struct Payment: Codable {
    var amount: Double
    var date: Date
    var collectedBy: Employee
    var notes: String?
    
    static let paymentDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
//    static var ArchiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("customerPayments").appendingPathExtension("plist")
//
//    static func save(payments: [Payment]) {
//        let propertyListEncoder = PropertyListEncoder()
//        let savedPayments = try? propertyListEncoder.encode(payments)
//        try? savedPayments?.write(to: ArchiveURL, options: .noFileProtection)
//    }
//
//    static func loadPayments() -> [Payment]? {
//        guard let savedPayments = try? Data(contentsOf: ArchiveURL) else { return nil}
//        let propertyListDecoder = PropertyListDecoder()
//
//        return try? propertyListDecoder.decode([Payment].self, from: savedPayments)
//    }
//
//    static var all: [Payment]? {
//        return loadPayments()
//    }
}

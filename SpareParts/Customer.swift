//
//  Customer.swift
//  SpareParts
//
//  Created by Anas Bashandy on 3/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import Foundation

struct Customer: Equatable, Codable {
    
    var name: String
    var payments: [Payment]?
    
    var relatedCustomerOrders: [CustomerOrder]? {
        return CustomerOrder.all?.filter { $0.customer == self }
    }
    
    var totalDue: Double {
        var result = 0.0
        for order in relatedCustomerOrders ?? [CustomerOrder]() {
            result += order.totalDue
        }
        for payment in payments ?? [Payment]() {
            result -= payment.amount
        }
        return result
    }
    
    static func ==(lhs: Customer, rhs: Customer) -> Bool {
        return lhs.name == rhs.name
    }
    
    static var ArchiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("customers").appendingPathExtension("plist")
    
    static func save(customers: [Customer]) {
        let propertyListEncoder = PropertyListEncoder()
        let savedCustomers = try? propertyListEncoder.encode(customers)
        try? savedCustomers?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadCustomers() -> [Customer]? {
        guard let savedCustomers = try? Data(contentsOf: ArchiveURL) else { return nil}
        let propertyListDecoder = PropertyListDecoder()
        
        return try? propertyListDecoder.decode([Customer].self, from: savedCustomers)
    }
    
    static var all: [Customer]? {
        return loadCustomers()
    }
}

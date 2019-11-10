//
//  Customer.swift
//  SpareParts
//
//  Created by Anas Bashandy on 3/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import Foundation

struct Customer: Codable {
    
    var name: String
    
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

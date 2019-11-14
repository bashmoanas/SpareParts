//
//  Employee.swift
//  SpareParts
//
//  Created by Anas Bashandy on 12/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import Foundation

struct Employee: Comparable, Codable {
    var name: String
    
    static func <(lhs: Employee, rhs: Employee) -> Bool {
        return lhs.name < rhs.name
    }
    
    static var ArchiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("emplyees").appendingPathExtension("plist")
    
    static func save(emplyees: [Employee]) {
        let propertyListEncoder = PropertyListEncoder()
        let savedEmployees = try? propertyListEncoder.encode(emplyees)
        try? savedEmployees?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadEmployees() -> [Employee]? {
        guard let savedEmployees = try? Data(contentsOf: ArchiveURL) else { return nil}
        let propertyListDecoder = PropertyListDecoder()
        
        return try? propertyListDecoder.decode([Employee].self, from: savedEmployees)
    }
    
    static var all: [Employee]? {
        return loadEmployees()
    }
}

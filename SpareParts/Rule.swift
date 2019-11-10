//
//  Rule.swift
//  SpareParts
//
//  Created by Anas Bashandy on 16/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import Foundation

struct Rule: CustomStringConvertible, Equatable, Comparable , Codable {
    
    var cost: Double
    var profit: Double
    
    var description: String {
        return """
        When cost is less than \(cost.convertToEgyptianCurrency)
        Then profit is \(profit.cleaned)%
        """
    }
    
    static func ==(lhs: Rule, rhs: Rule) -> Bool {
        return lhs.cost == rhs.cost
    }
    
    static func < (lhs: Rule, rhs: Rule) -> Bool {
        return lhs.cost < rhs.cost
    }
    
    static var ArchiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("savedRules").appendingPathExtension("plist")
    
    static func save(_ rules: [Rule]) {
        let propertyListEncoder = PropertyListEncoder()
        let savedRules = try? propertyListEncoder.encode(rules)
        try? savedRules?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadSavedRules() -> [Rule]? {
        guard let savedRules = try? Data(contentsOf: ArchiveURL) else { return nil}
        let propertyListDecoder = PropertyListDecoder()
        
        return try? propertyListDecoder.decode([Rule].self, from: savedRules)
    }
}

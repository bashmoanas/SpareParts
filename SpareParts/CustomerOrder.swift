//
//  CustomerOrder.swift
//  SpareParts
//
//  Created by Anas Bashandy on 3/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import Foundation

struct CustomerOrder: Codable {
    var orderNumber: String
    var date = Date()
    var customer: Customer?
    var spareParts: [SparePart: Int]
    
    static let orderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var totalDue: Double {
        var sparePartsTotalPrice = [Double]()
        for (sparePart, quantity) in spareParts {
            if let salePrice = sparePart.otherSalePrice {
                let pricePerSparePart = salePrice * Double(quantity)
                sparePartsTotalPrice.append(pricePerSparePart)
            } else if let salePrice = sparePart.alternativeSalePrice {
                let pricePerSparePart = salePrice * Double(quantity)
                sparePartsTotalPrice.append(pricePerSparePart)
            } else {
                let pricePerSparePart = sparePart.salePrice * Double(quantity)
                sparePartsTotalPrice.append(pricePerSparePart)
            }
            
        }

        return sparePartsTotalPrice.reduce(0) { (currentTotal, salePrice) -> Double in
            return currentTotal + salePrice
        }
    }
        
    static var allSoldSparePartsWithQuantities: [SparePart: Int] {
        var allSoldSpareParts = [SparePart: Int]()
        guard let customerOrders = CustomerOrder.all else { return [SparePart: Int]() }
        for customerOrder in customerOrders {
            for (sparePart, quantity) in customerOrder.spareParts {
                if allSoldSpareParts.keys.contains(sparePart) {
                    let oldQuantity = allSoldSpareParts[sparePart]!
                    allSoldSpareParts.updateValue((oldQuantity + quantity), forKey: sparePart)
                } else {
                    allSoldSpareParts[sparePart] = quantity
                }

            }
        }
        return allSoldSpareParts
    }
        
    static var ArchiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("customerOrders").appendingPathExtension("plist")
    
    static func save(customerOrders: [CustomerOrder]) {
        let propertyListEncoder = PropertyListEncoder()
        let savedCustomerOrders = try? propertyListEncoder.encode(customerOrders)
        try? savedCustomerOrders?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadCustomerOrders() -> [CustomerOrder]? {
        guard let savedCustomerOrders = try? Data(contentsOf: ArchiveURL) else { return nil}
        let propertyListDecoder = PropertyListDecoder()
        
        return try? propertyListDecoder.decode([CustomerOrder].self, from: savedCustomerOrders)
    }
    
    static var all: [CustomerOrder]? {
        return loadCustomerOrders()
    }
}

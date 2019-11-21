//
//  PurchaseOrder.swift
//  SpareParts
//
//  Created by Anas Bashandy on 27/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import Foundation

struct PurchaseOrder: Codable {
    var orderNumber: String
    var date = Date()
    var invoiceNumber: Int?
    var spareParts: [SparePart: Int]
    var courierChargeJPY: Double?
    var jpyValue: Double?
    var totalCustom: Double?
    var vat: Double?
    
    static var orderNumberFactory = 0
    
    static func generateOrderNumber() -> String {
        orderNumberFactory += 1
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        
        return "\(orderNumberFactory)\(year)"
    }
    
    var fobtotalCostJPY: Double {
        var sparePartsTotalCost = [Double]()
        for (sparePart, quantity) in spareParts {
            let pricePerSparePart = sparePart.priceInJPY * Double(quantity)
            sparePartsTotalCost.append(pricePerSparePart)
        }

        return sparePartsTotalCost.reduce(0) { (currentTotal, priceInJPY) -> Double in
            return currentTotal + priceInJPY
        }
    }
    
    var ciftotalCostJPY: Double {
        return fobtotalCostJPY + (courierChargeJPY ?? 0)
    }
    
    var fobEGP: Double {
        return fobtotalCostJPY * (jpyValue ?? 0)
    }
    
    var cifEGP: Double {
        return ciftotalCostJPY * (jpyValue ?? 0)
    }
    
    var customWithoutVAT: Double {
        return (totalCustom ?? 0) - (vat ?? 0)
    }
    
    var fotocolor: Double {
        return fobEGP * 0.04
    }
    
    var totalCostWithoutVAT: Double {
        var cost = cifEGP + customWithoutVAT
        cost += fotocolor
        cost += (0.1 * fotocolor)
        return cost
    }
    
    var costFactor: Double {
        return totalCostWithoutVAT / fobtotalCostJPY
    }
    
    var averageCostPerSparePart: [SparePart: Double] {
        var cost = [SparePart: Double]()
        for sparePart in spareParts.keys {
            cost[sparePart] = sparePart.priceInJPY * costFactor
        }
        return cost
    }
    
    static let orderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static var allPurchasedSparePartsWithQuantities: [SparePart: Int] {
        var allPurchasedSpareParts = [SparePart: Int]()
        guard let purchaseOrders = PurchaseOrder.all else { return [SparePart: Int]() }
        for purchaseOrder in purchaseOrders {
            for (sparePart, quantity) in purchaseOrder.spareParts {
                if allPurchasedSpareParts.keys.contains(sparePart) {
                    let oldQuantity = allPurchasedSpareParts[sparePart]!
                    allPurchasedSpareParts.updateValue((oldQuantity + quantity), forKey: sparePart)
                } else {
                    allPurchasedSpareParts[sparePart] = quantity
                }

            }
        }
        return allPurchasedSpareParts
    }
    
    static var allPurchasesTotal: Double? {
        var total = 0.0
        
        guard let allPurchases = PurchaseOrder.all else { return nil }
        
        for purchase in allPurchases {
            let amount = purchase.ciftotalCostJPY
            total += amount
        }
        
        return total
    }
            
    static var ArchiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("purchaseOrders").appendingPathExtension("plist")
    
    static func save(purchaseOrders: [PurchaseOrder]) {
        let propertyListEncoder = PropertyListEncoder()
        let savedPurchaseOrders = try? propertyListEncoder.encode(purchaseOrders)
        try? savedPurchaseOrders?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadPurchaseOrders() -> [PurchaseOrder]? {
        guard let savedPurchaseOrders = try? Data(contentsOf: ArchiveURL) else { return nil}
        let propertyListDecoder = PropertyListDecoder()
        
        return try? propertyListDecoder.decode([PurchaseOrder].self, from: savedPurchaseOrders)
    }
    
    static var all: [PurchaseOrder]? {
        return loadPurchaseOrders()
    }
}

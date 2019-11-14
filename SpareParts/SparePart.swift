//
//  SparePart.swift
//  SpareParts
//
//  Created by Anas Bashandy on 15/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import Foundation
import PDFKit

class SparePart: Codable, Comparable {
    
    var details: String
    var partNumber: String
    var priceInJPY: Double
    var alternativeSalePrice: Double?
    var otherSalePrice: Double? { didSet { SparePart.save(spareParts: SparePart.all!) } }
    var restockLevel: Int?
    var isDiscontinued = false
    
    var currentStock: Int {
        return (PurchaseOrder.allPurchasedSparePartsWithQuantities[self] ?? 0) - (CustomerOrder.allSoldSparePartsWithQuantities[self] ?? 0)
    }
    
    var requiredStockForPurchase: Int? {
        if restockLevel != nil && restockLevel! - currentStock > 0 {
            return restockLevel! - currentStock
        } else {
            return nil
        }
    }
    
    var cost: Double {
        return priceInJPY * SparePart.costFactor
    }
    
    var totalItemsPurchased: Int {
        return PurchaseOrder.allPurchasedSparePartsWithQuantities[self] ?? 0
    }
    
    var averageCost: Double {
        return calculateAverageCost(for: self)
    }
    
    var currentStockCost: Double {
        return Double(currentStock) * averageCost
    }
    
    var totalItemsSold: Int {
        return CustomerOrder.allSoldSparePartsWithQuantities[self] ?? 0
    }
    
    var salePrice: Double {
        if let rules = Rule.loadSavedRules()?.sorted(by: <) {
            for rule in rules where rule.cost >= cost {
                let price = (cost + (cost * (rule.profit / 100)))
                return price > 1000 ? price.rounded(to: 100) : price.rounded(to: 10)
            }
        }
        return (cost + (cost * SparePart.noRuleProfit / 100)).rounded(to: 100)
    }
    
    var relatedPurchaseOrders: [PurchaseOrder]? {
        return PurchaseOrder.all?.filter { $0.spareParts.keys.contains(self) }
    }
    
    var relatedCustomerOrders: [CustomerOrder]? {
        return CustomerOrder.all?.filter { $0.spareParts.keys.contains(self) }
    }
    
    static var currentInventoryCount: Int {
        let spareParts = SparePart.all!
        var currentCount = 0
        
        for sparePart in spareParts {
            currentCount += sparePart.currentStock
        }
        
        return currentCount
    }
    
    static var currentInventoryCost: Double {
        let spareParts = SparePart.all!
        var currentCost = 0.0
        
        for sparePart in spareParts {
            currentCost += sparePart.averageCost
        }
        
        return currentCost
    }
    
    init(details: String, partNumber: String, priceInJPY: Double, alternativeSalePrice: Double?, otherSalePrice: Double?, restockLevel: Int?) {
        self.details = details
        self.partNumber = partNumber
        self.priceInJPY = priceInJPY
        self.alternativeSalePrice = alternativeSalePrice
        self.otherSalePrice = otherSalePrice
        self.restockLevel = restockLevel
    }
    
    func calculateAverageCost(for sparePart: SparePart) -> Double {
        
        let currentPurchaseOrder: PurchaseOrder
        let currentPurchaseIndex: Int
        let previousPurchaseOrder: PurchaseOrder?
        
        if let purchaseOrders = PurchaseOrder.all?.filter({ (purchaseOrder) -> Bool in
            return purchaseOrder.spareParts.keys.contains(sparePart)
        }) {
            if purchaseOrders.count == 0 {
                return 0
            } else if purchaseOrders.count == 1 {
                return purchaseOrders.last?.averageCostPerSparePart[sparePart] ?? 0
            } else {
                currentPurchaseOrder = purchaseOrders.last!
                currentPurchaseIndex = (purchaseOrders.endIndex) - 1
                previousPurchaseOrder = purchaseOrders[currentPurchaseIndex - 1]
                
                let previousQuantity = previousPurchaseOrder?.spareParts[sparePart]!
                let previousCost = previousPurchaseOrder?.averageCostPerSparePart[sparePart]!
                let currentQuantity = currentPurchaseOrder.spareParts[sparePart]!
                let currentCost = currentPurchaseOrder.averageCostPerSparePart[sparePart]!
                
                let firstPartOfTheEquation = ((Double(previousQuantity!) * previousCost!) + (Double(currentQuantity) * currentCost))
                
                return (firstPartOfTheEquation / Double((previousQuantity! + currentQuantity)))
            }
        }
        
        return 0
    }
    
    static var costFactor: Double = UserDefaults.standard.double(forKey: "CostFactor")
    static var noRuleProfit: Double = UserDefaults.standard.double(forKey: "NoRuleProfit")
    
    static func ==(lhs: SparePart, rhs: SparePart) -> Bool {
        lhs.partNumber == rhs.partNumber
    }
    
    static func <(lhs: SparePart, rhs: SparePart) -> Bool {
        return lhs.partNumber < rhs.partNumber
    }
    
    static var ArchiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("spareParts").appendingPathExtension("plist")
    
    static func save(spareParts: [SparePart]) {
        let propertyListEncoder = PropertyListEncoder()
        let savedSpareParts = try? propertyListEncoder.encode(spareParts)
        try? savedSpareParts?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadSpareParts() -> [SparePart]? {
        guard let savedSpareParts = try? Data(contentsOf: ArchiveURL) else { return nil}
        let propertyListDecoder = PropertyListDecoder()
        
        return try? propertyListDecoder.decode([SparePart].self, from: savedSpareParts)
    }
    
    static var all: [SparePart]? {
        return loadSpareParts()
    }
}

extension SparePart: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(partNumber)
    }
}

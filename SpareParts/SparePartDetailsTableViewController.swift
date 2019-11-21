//
//  SparePartDetailsTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 22/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class SparePartDetailsTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var restockLevelLabel: UILabel!
    
    @IBOutlet weak var salePriceLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    @IBOutlet weak var priceInJPYLabel: UILabel!
    @IBOutlet weak var totalItemsPurchasedLabel: UILabel!
    @IBOutlet weak var averageCostPerItemLabel: UILabel!
    @IBOutlet weak var currentStockCostLabel: UILabel!
    
    @IBOutlet weak var totalItemsSoldLabel: UILabel!
    @IBOutlet weak var totalSales: UILabel!
    
    @IBOutlet weak var isDiscontinuedSwitch: UISwitch!
    
    var sparePart: SparePart?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let sparePart = sparePart {
            detailsLabel.text =
            """
            \(sparePart.partNumber)
            \(sparePart.details)
            """
            stockLabel.text = "\(sparePart.currentStock)"
            costLabel.text = "\(sparePart.cost)"
            priceInJPYLabel.text = "\(sparePart.priceInJPY.convertToJapaneseCurrency)"
            if sparePart.alternativeSalePrice != nil {
                salePriceLabel.text = "\(sparePart.alternativeSalePrice!.convertToEgyptianCurrency)"
            } else {
                salePriceLabel.text = "\(sparePart.salePrice.convertToEgyptianCurrency)"
            }
            costLabel.text = "\(sparePart.cost.convertToEgyptianCurrency)"
            totalItemsPurchasedLabel.text = "\(sparePart.totalItemsPurchased)"
            totalItemsSoldLabel.text = "\(sparePart.totalItemsSold)"
            averageCostPerItemLabel.text = "\(sparePart.calculateAverageCost(for: sparePart).convertToEgyptianCurrency)"
            currentStockCostLabel.text = "\(sparePart.currentStockCost.convertToEgyptianCurrency)"
            restockLevelLabel.text = (sparePart.restockLevel != nil) ? "\(sparePart.restockLevel!)" : "Not Set"
            isDiscontinuedSwitch.isOn = sparePart.isDiscontinued
            
            let currentStock = sparePart.currentStock
            let restockLevel = sparePart.restockLevel ?? 0
            
            if currentStock < restockLevel {
                stockLabel.textColor = .red
            }
        }
    }
    
    @IBAction func isDiscontinuedToggled(_ sender: UISwitch) {
        sparePart?.isDiscontinued = sender.isOn
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditSparePart" {
            let destinationViewController = segue.destination as! EditSparePartTableViewController
            destinationViewController.title = sparePart?.partNumber
            destinationViewController.sparePart = sparePart
        }
    }
//
//    @IBAction func unwindToSparePartView(segue: UIStoryboardSegue) {
//        guard segue.identifier == "SaveUnwind" else { return }
//        if let sourceViewController = segue.source as? EditSparePartTableViewController {
//            sparePart = sourceViewController.sparePart
//        }
//    }
//
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        guard let sparePart = sparePart,
//            let destinationViewController = viewController as? SparePartsListTableViewController else { return }
//        let indexPath = destinationViewController.selectedIndexPath!
//        destinationViewController.spareParts[indexPath.row] = sparePart
//        SparePart.save(spareParts: destinationViewController.spareParts)
//        destinationViewController.tableView.reloadData()
//    }
    
}

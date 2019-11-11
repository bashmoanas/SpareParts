//
//  SparePartsListTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 15/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class SparePartsListTableViewController: UITableViewController {
    
    let userDefaults = UserDefaults.standard
    var spareParts = [SparePart]()
    var selectedIndexPath: IndexPath?
    var allPurchases = PurchaseOrder.allPurchasedSparePartsWithQuantities
    var allSales = CustomerOrder.allSoldSparePartsWithQuantities
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        if let savedSpareParts = SparePart.all {
            spareParts = savedSpareParts
            spareParts = spareParts.sorted(by: <)
            }        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spareParts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sparePartCell", for: indexPath)
        let sparePart = spareParts[indexPath.row]
        
        let priceToDisplay = sparePart.alternativeSalePrice != nil ? "\(sparePart.alternativeSalePrice!.convertToEgyptianCurrency)" : "\(sparePart.salePrice.convertToEgyptianCurrency)"
        
        cell.textLabel?.text =
        """
        \(sparePart.partNumber)
        \(priceToDisplay)
        """
        cell.detailTextLabel?.text =
        """
        \(sparePart.details)
        \(sparePart.currentStock)
        """
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            spareParts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            SparePart.save(spareParts: spareParts)
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    @IBAction func shareSparePartsList(_ sender: UIBarButtonItem) {
        let fileName = "Current Stock.csv"
        let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "Part Number,Description,Current Stock, Sale Price\n"
        for sparePart in spareParts {
            let priceToDisplay = sparePart.alternativeSalePrice ?? sparePart.salePrice
            let newLine = "\(sparePart.partNumber),\(sparePart.details),\(sparePart.currentStock),\(priceToDisplay) EGP\n"
            csvText.append(contentsOf: newLine)
        }
        try? csvText.write(to: path, atomically: true, encoding: .utf8)
        let activityController = UIActivityViewController(activityItems: [path], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PriceCalculatorSegue",
            let destinationViewController = segue.destination as? PriceCalculatorTableViewController {
            destinationViewController.costFactor = userDefaults.double(forKey: "CostFactor")
            destinationViewController.noRuleProfit = userDefaults.double(forKey: "NoRuleProfit")
        } else if segue.identifier == "ViewSparePart" {
            selectedIndexPath = tableView.indexPathForSelectedRow
            let sparePart = spareParts[selectedIndexPath!.row]
            let destinationViewController = segue.destination as! SparePartDetailsTableViewController
            destinationViewController.title = sparePart.partNumber
            destinationViewController.sparePart = sparePart
        }
    }
    
    @IBAction func unwindToSparePartsListTableViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveUnwind",
            let sourceViewController = segue.source as? AddSparePartTableViewController,
            let sparePart = sourceViewController.sparePart else { return }
        
        let newIndexPath = IndexPath(row: spareParts.count, section: 0)
        spareParts.append(sparePart)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        SparePart.save(spareParts: spareParts)
    }
    
}

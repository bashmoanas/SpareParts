//
//  PurchaseOrdersListTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 27/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class PurchaseOrdersListTableViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var purchaseOrders = [PurchaseOrder]()
    var relatedPurchaseOrders: [PurchaseOrder]?
    var selectedSpareParts = [SparePart: Int]()
    let year = Calendar.current.component(.year, from: Date())
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let relatedPurchaseOrders = relatedPurchaseOrders {
            purchaseOrders = relatedPurchaseOrders
        } else if let savedPurchaseOrders = PurchaseOrder.all {
            purchaseOrders = savedPurchaseOrders
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseOrders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseOrderCell", for: indexPath)
        let purchaseOrder = purchaseOrders[indexPath.row]
        cell.textLabel?.text =
        """
        \(purchaseOrder.orderNumber)
        \(PurchaseOrder.orderDateFormatter.string(from: Date()))
        """
        cell.detailTextLabel?.text = "\(purchaseOrder.fobtotalCostJPY.convertToJapaneseCurrency)"
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            purchaseOrders.remove(at: indexPath.row)
            PurchaseOrder.save(purchaseOrders: purchaseOrders)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewPurchaseOrder" {
            selectedIndexPath = tableView.indexPathForSelectedRow
            let purchaseOrder = purchaseOrders[selectedIndexPath!.row]
            let destinationViewController = segue.destination as! ViewPurchaseOrderTableViewController
            destinationViewController.title = purchaseOrder.orderNumber
            destinationViewController.purchaseOrder = purchaseOrder
        }
    }
    
    @IBAction func unwindToPurchaseOrdersListTableViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "AddSegue",
            let sourceViewController = segue.source as? AddPurchaseOrderTableViewController else { return }
        selectedSpareParts = sourceViewController.selectedSpareParts
        let newPurchaseOrder = PurchaseOrder(orderNumber: "\(purchaseOrders.count + 1)\(year)", spareParts: selectedSpareParts)
        purchaseOrders.append(newPurchaseOrder)
        PurchaseOrder.save(purchaseOrders: purchaseOrders)
        tableView.reloadData()
    }
    
}

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
    var selectedSpareParts = [SparePart: Int]()
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedPurchaseOrders = PurchaseOrder.all {
            purchaseOrders = savedPurchaseOrders
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return purchaseOrders.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoritsuCell", for: indexPath)
            cell.detailTextLabel?.text = "\(NoritsuPayment.currentNoritsuBalance?.convertToJapaneseCurrency ?? "")"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseOrderCell", for: indexPath)
            let purchaseOrder = purchaseOrders[indexPath.row]
            cell.textLabel?.text = "\(PurchaseOrder.orderDateFormatter.string(from: Date()))"
            cell.detailTextLabel?.text = "\(purchaseOrder.fobtotalCostJPY.convertToJapaneseCurrency)"
            return cell
        }
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return false
        default:
            return true
        }
        
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            purchaseOrders.remove(at: indexPath.row)
            PurchaseOrder.save(purchaseOrders: purchaseOrders)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 1 ? "Purchase Orders" : ""
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewPurchaseOrder" {
            selectedIndexPath = tableView.indexPathForSelectedRow
            let purchaseOrder = purchaseOrders[selectedIndexPath!.row]
            let destinationViewController = segue.destination as! ViewEditPurchaseOrderTableViewController
            destinationViewController.title = purchaseOrder.orderNumber
            destinationViewController.order = purchaseOrder
        } else if segue.identifier == "" {
            guard let sourceViewController = segue.source as? ViewEditPurchaseOrderTableViewController, let order = sourceViewController.order,
                let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
            purchaseOrders[selectedIndexPath.row] = order
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        }
    }
    
    @IBAction func unwindToPurchaseOrdersListTableViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveUnwindFromAddPurchaseOrder",
            let sourceViewController = segue.source as? AddPurchaseOrderTableViewController else { return }
        selectedSpareParts = sourceViewController.selectedSpareParts
        let newPurchaseOrder = PurchaseOrder(orderNumber: PurchaseOrder.generateOrderNumber(), spareParts: selectedSpareParts)
        purchaseOrders.append(newPurchaseOrder)
        PurchaseOrder.save(purchaseOrders: purchaseOrders)
        tableView.reloadData()
    }
}

//
//  ViewEditPurchaseOrderTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 20/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class ViewEditPurchaseOrderTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var order: PurchaseOrder?
    var spareParts = [SparePart: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        spareParts = order?.spareParts ?? [SparePart: Int]()
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return spareParts.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        default:
            return "Spare Parts"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseOrderTotalDueFOBCell", for: indexPath)
            cell.detailTextLabel?.text = "\(order?.fobtotalCostJPY.convertToJapaneseCurrency ?? "")"
            return cell
        default:
            let purchaseOrderparePartsCell = tableView.dequeueReusableCell(withIdentifier: "PurchaseOrderSparePartCell", for: indexPath)
            
            let orderSpareParts = Array(spareParts.keys).sorted(by: <)
            let orderQuantities = Array(spareParts.values)
            
            let currentSparePart = orderSpareParts[indexPath.row]
            let currentQuantity = orderQuantities[indexPath.row]
            
            purchaseOrderparePartsCell.textLabel?.text = currentSparePart.partNumber
            purchaseOrderparePartsCell.detailTextLabel?.text = "\(currentQuantity)"
            
            
            
            return purchaseOrderparePartsCell
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditPOSparePart" {
            let destinationViewController = segue.destination as! EditPOSparePartsTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let orderSpareParts = Array(spareParts.keys)
            let orderQuantities = Array(spareParts.values)
            
            let currentSparePart = orderSpareParts[indexPath.row]
            let currentQuantity = orderQuantities[indexPath.row]
            
            destinationViewController.title = currentSparePart.details
            destinationViewController.order = order
            destinationViewController.sparePart = currentSparePart
            destinationViewController.quantity = currentQuantity
        } else if segue.identifier == "EditPurchaseOrderDetails" {
            let destinationViewController = segue.destination as! EditPurchaseOrderDetailsTableViewController
            destinationViewController.title = "\(order?.orderNumber ?? "")"
            destinationViewController.order = order
        }
    }
    
    @IBAction func unwindToViewEditPurchaseOrder(segue: UIStoryboardSegue) {
        if segue.identifier == "SaveUnwindFromEditPurchasaeOrderDetails" {
            let sourceViewController = segue.source as! EditPurchaseOrderDetailsTableViewController
            order = sourceViewController.order
            tableView.reloadData()
        } else if segue.identifier == "SaveUnwindFromEditPOSpareParts" {
            let sourceViewController = segue.source as! EditPOSparePartsTableViewController
            
            let indexPath = tableView.indexPathForSelectedRow!
            let sparePart = Array(spareParts.keys)[indexPath.row]
            spareParts[sparePart] = sourceViewController.quantity
            order?.spareParts = spareParts
            tableView.reloadData()
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let destinationViewController = viewController as? PurchaseOrdersListTableViewController else { return }
        
        let indexPath = destinationViewController.selectedIndexPath!
        destinationViewController.purchaseOrders[indexPath.row] = order!
        PurchaseOrder.save(purchaseOrders: destinationViewController.purchaseOrders)
        destinationViewController.tableView.reloadData()
    }
    
    
}

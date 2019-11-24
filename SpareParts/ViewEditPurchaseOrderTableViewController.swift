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
    var sortedSpareParts = [SparePart]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sortedSpareParts = Array(order!.spareParts.keys).sorted(by: <)
        
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
            return sortedSpareParts.count
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
            let sparePart = sortedSpareParts[indexPath.row]
            
            purchaseOrderparePartsCell.textLabel?.text = sparePart.partNumber
            purchaseOrderparePartsCell.detailTextLabel?.text = "\(order?.spareParts[sparePart] ?? 0)"
            
            return purchaseOrderparePartsCell
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return false
        default:
            return true
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removedSparePart = sortedSpareParts.remove(at: indexPath.row)
            order?.spareParts.removeValue(forKey: removedSparePart)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditPOSparePart" {
            let destinationViewController = segue.destination as! EditPOSparePartsTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let sparePart = sortedSpareParts[indexPath.row]
            let quantity = order?.spareParts[sparePart]
            
            destinationViewController.title = sparePart.details
            destinationViewController.order = order
            destinationViewController.sparePart = sparePart
            destinationViewController.quantity = quantity
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
            let sparePart = sortedSpareParts[indexPath.row]
            order?.spareParts[sparePart] = sourceViewController.quantity
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

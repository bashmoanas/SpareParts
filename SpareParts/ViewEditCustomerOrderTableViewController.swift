//
//  ViewCustomerOrderTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 3/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class ViewEditCustomerOrderTableViewController: UITableViewController {
    
    var order: CustomerOrder?
    var spareParts = [SparePart: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spareParts = order?.spareParts ?? [SparePart: Int]()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
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
            if indexPath.row == 0 {
                let orderDateCell = tableView.dequeueReusableCell(withIdentifier: "OrderDateCell", for: indexPath)
                orderDateCell.detailTextLabel?.text = "\(CustomerOrder.orderDateFormatter.string(from: order?.date ?? Date()))"
                return orderDateCell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TotalDueCell", for: indexPath)
                cell.detailTextLabel?.text = "\(order?.totalDue.convertToEgyptianCurrency ?? "")"
                return cell
            }
        default:
            let sparePartsCell = tableView.dequeueReusableCell(withIdentifier: "SparePartCell", for: indexPath)
            
            let orderSpareParts = Array(spareParts.keys)
            let orderQuantities = Array(spareParts.values)
            
            let currentSparePart = orderSpareParts[indexPath.row]
            let currentQuantity = orderQuantities[indexPath.row]
            
            sparePartsCell.textLabel?.text = currentSparePart.partNumber
            sparePartsCell.detailTextLabel?.text = "\(currentQuantity)"
            
            
            
            return sparePartsCell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditDate" {
            let destinationViewController = segue.destination as! EditDateTableViewController
            destinationViewController.title = "Edit Order Date"
            destinationViewController.order = order
        }
    }
    
    @IBAction func unwindToViewEditCustomerOrder(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveUnwindFromEditDate" else { return }
        let sourceViewController = segue.source as! EditDateTableViewController
        order = sourceViewController.order
    }
    
}

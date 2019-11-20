//
//  AddPurchaseOrderTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 27/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class AddPurchaseOrderTableViewController: UITableViewController, PurchaseOrderCellDelegate {
    
    var availableSpareParts = [SparePart]()
    var selectedSpareParts = [SparePart: Int]()
    lazy var quantities = Array(repeating: 1, count: availableSpareParts.count)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedSpareParts = SparePart.all {
            availableSpareParts = savedSpareParts
            availableSpareParts = availableSpareParts.sorted(by: <)
        }
        
        isEditing = true
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SparePart.all?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseOrderSparePartCell", for: indexPath) as! PurchaseOrderCell
        cell.delegate = self
        let sparePart = availableSpareParts[indexPath.row]
        cell.stepper.value = 1
        cell.update(with: sparePart)
        
//        cell.textLabel?.text =
//        """
//        \(sparePart.partNumber)
//        \(sparePart.priceInJPY.convertToJapaneseCurrency)
//        """
//        cell.detailTextLabel?.text =
//        """
//        \(sparePart.details)
//
//        """
        return cell
    }
    
    
    func set(quantity: Int, sender: PurchaseOrderCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            quantities[indexPath.row] = quantity
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        {
//            super.prepare(for: segue, sender: sender)
//            
//            guard segue.identifier == "SaveUnwindFromAddOrder" else { return }
//            if let selectedRows = tableView.indexPathsForSelectedRows {
//                for indexPath in selectedRows {
//                    let sparePart = self.availableSpareParts[indexPath.row]
//                    let quantity = quantities[indexPath.row]
//                    selectedSpareParts[sparePart] = quantity
//                }
//                
//                
//            }
//        }
        
        
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "SaveUnwindFromAddPurchaseOrder" else { return }
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                let sparePart = self.availableSpareParts[indexPath.row]
                let quantity = quantities[indexPath.row]
                self.selectedSpareParts[sparePart] = quantity
            }
        }
    }
}

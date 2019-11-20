//
//  AddEditCustomerOrderTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 14/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class AddCustomerOrderTableViewController: UITableViewController, CustomerOrderCellDelegate {
    
    var availableSpareParts = [SparePart]()
    var selectedSpareParts = [SparePart: Int]()
    lazy var quantities = Array(repeating: 1, count: availableSpareParts.count)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isEditing = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let savedSpareParts = SparePart.all {
            for sparePart in savedSpareParts {
                if sparePart.currentStock > 0 {
                    availableSpareParts.append(sparePart)
                }
            }
            
        }
        availableSpareParts = availableSpareParts.sorted(by: <)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableSpareParts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerOrderSparePartCell", for: indexPath) as! CustomerOrderCell
        cell.delegate = self
        let sparePart = availableSpareParts[indexPath.row]
        cell.stepper.value = 1
        cell.update(with: sparePart)
        
//        if let salePrice = sparePart.alternativeSalePrice {
//            cell.textLabel?.text =
//            """
//            \(sparePart.partNumber)
//            \(salePrice.convertToEgyptianCurrency)
//            """
//        } else {
//            cell.textLabel?.text =
//            """
//            \(sparePart.partNumber)
//            \(sparePart.salePrice.convertToEgyptianCurrency)
//            """
//        }
        
//        cell.detailTextLabel?.text =
//        """
//        \(sparePart.details)
//        \(sparePart.currentStock)
//        """
//        
        return cell
    }
    
    func set(quantity: Int, sender: CustomerOrderCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            quantities[indexPath.row] = quantity
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "SaveUnwindFromAddOrder" else { return }
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                let sparePart = self.availableSpareParts[indexPath.row]
                let quantity = quantities[indexPath.row]
                selectedSpareParts[sparePart] = quantity
            }
            
            
        }
    }
}

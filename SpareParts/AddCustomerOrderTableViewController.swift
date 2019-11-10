//
//  AddCustomerOrderTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 3/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class AddCustomerOrderTableViewController: UITableViewController {
    
    var availableSpareParts = [SparePart]()
    var selectedSpareParts = [SparePart: Int]()
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerOrderSparePartCell", for: indexPath)
        let sparePart = availableSpareParts[indexPath.row]
        if let salePrice = sparePart.alternativeSalePrice {
            cell.textLabel?.text =
            """
            \(sparePart.partNumber)
            \(salePrice.convertToEgyptianCurrency)
            """
        } else {
            cell.textLabel?.text =
            """
            \(sparePart.partNumber)
            \(sparePart.salePrice.convertToEgyptianCurrency)
            """
        }
        
        cell.detailTextLabel?.text =
        """
        \(sparePart.details)
        \(sparePart.currentStock)
        """
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                let sparePart = self.availableSpareParts[indexPath.row]
                self.selectedSpareParts[sparePart] = 1
            }
        }
    }
}

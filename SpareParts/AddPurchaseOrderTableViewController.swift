//
//  AddPurchaseOrderTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 27/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class AddPurchaseOrderTableViewController: UITableViewController {
    
    var availableSpareParts = [SparePart]()
    var selectedSpareParts = [SparePart: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedSpareParts = SparePart.all {
            availableSpareParts = savedSpareParts
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseOrderSparePartCell", for: indexPath)
        let sparePart = availableSpareParts[indexPath.row]
        cell.textLabel?.text =
        """
        \(sparePart.partNumber)
        \(sparePart.priceInJPY.convertToJapaneseCurrency)
        """
        cell.detailTextLabel?.text =
        """
        \(sparePart.details)
        
        """        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                let sparePart = self.availableSpareParts[indexPath.row]
                self.selectedSpareParts[sparePart] = 1
                print("\(sparePart.partNumber): \(sparePart.currentStock)")
            }
        }
    }
}

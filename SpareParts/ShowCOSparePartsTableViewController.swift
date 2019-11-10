//
//  ShowCOSparePartsTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 4/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class ShowCOSparePartsTableViewController: UITableViewController {
    
    var customerOrder: CustomerOrder?
    var spareParts = [SparePart: Int]()
    var sortedSpareParts = [SparePart]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let customerOrder = customerOrder else { return }
        spareParts = customerOrder.spareParts
        sortedSpareParts = spareParts.keys.sorted(by: <)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 1
        default:
            return sortedSpareParts.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCOSpareParts", for: indexPath)
            let sparePart = sortedSpareParts[indexPath.row]
            
            cell.textLabel?.text = "\(sparePart.partNumber)"
            cell.detailTextLabel?.text = "\(customerOrder!.spareParts[sparePart]!)"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCOSparePartsFOBJPY", for: indexPath)
            cell.textLabel?.text = "\(customerOrder?.totalDue.convertToEgyptianCurrency ?? "")"
            
            return cell
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "EditCOSPQuantity" else { return }
        
        let indexPath = tableView.indexPathForSelectedRow!
        let destinationViewController = segue.destination as! EditCOSparePartsTableViewController
        destinationViewController.customerOrder = customerOrder
        destinationViewController.sparePart = sortedSpareParts[indexPath.row]
    }
    
    @IBAction func unwindToShowCOSpareParts(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveUnwind" else { return }
        
        if let sourceViewController = segue.source as? EditCOSparePartsTableViewController {
            let quantity = sourceViewController.quantity
            if let indexPath = tableView.indexPathForSelectedRow {
                let sparePart = sortedSpareParts[indexPath.row]
                customerOrder!.spareParts[sparePart] = quantity
                tableView.reloadData()
            }
        }
    }
    
}

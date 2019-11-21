//
//  AllNoritsuPaymentsTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 20/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class AllNoritsuPaymentsTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var noritsuPayments = [NoritsuPayment]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedNoritsuPayments = NoritsuPayment.loadNoritsuPayments() {
            noritsuPayments = savedNoritsuPayments
            noritsuPayments = noritsuPayments.sorted(by: <)
        }
        
        navigationController?.delegate = self

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
        return noritsuPayments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoritsuPaymentCell", for: indexPath)
        let payment = noritsuPayments[indexPath.row]
        cell.textLabel?.text = NoritsuPayment.paymentDateFormatter.string(from: payment.date)
        cell.detailTextLabel?.text = "\(payment.amount.convertToJapaneseCurrency)"
        
        return cell
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
        guard segue.identifier == "EditPayment",
            let destinationViewController = segue.destination as? AddEditNoritsuPaymentTableViewController else { return }
        
        let selectetIndexPath = tableView.indexPathForSelectedRow!
        let payment = noritsuPayments[selectetIndexPath.row]
        destinationViewController.payment = payment
    }
    
    @IBAction func unwindToAllNoritsuPaymentsTableViewController(segue: UIStoryboardSegue) {
        if segue.identifier == "SaveUnwindFromAddEditNoritsuPayment", let sourceViewController = segue.source as? AddEditNoritsuPaymentTableViewController, let payment = sourceViewController.payment {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                noritsuPayments[selectedIndexPath.row] = payment
                tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            } else {
                let newIndexPath = IndexPath(row: noritsuPayments.count, section: 0)
                noritsuPayments.append(payment)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        NoritsuPayment.save(noritsuPayments: noritsuPayments)
        
    }
    
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        guard let destinationViewController = viewController as? PurchaseOrdersListTableViewController else { return }
//        
//        let indexPath = destinationViewController.selectedIndexPath!
//        destinationViewController.purchaseOrders[indexPath.row] = order!
//        PurchaseOrder.save(purchaseOrders: destinationViewController.purchaseOrders)
//        destinationViewController.tableView.reloadData()
//    }

}

//
//  CustomerTranasctionsTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 11/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class CustomerTranasctionsTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var customer: Customer?
    var payments = [Payment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let savedPayments = customer?.payments {
            payments = savedPayments
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return customer?.relatedCustomerOrders?.count ?? 0
        default:
            return payments.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalDueCell", for: indexPath)
            cell.textLabel?.text = "\(customer?.totalDue.convertToEgyptianCurrency ?? "")"
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
            guard let order = customer?.relatedCustomerOrders?[indexPath.row] else { return UITableViewCell()}
            cell.textLabel?.text = "\(CustomerOrder.orderDateFormatter.string(from: order.date))"
            cell.detailTextLabel?.text = "\(order.totalDue.convertToEgyptianCurrency)"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
            let payment = payments[indexPath.row]
            cell.textLabel?.text = "\(Payment.paymentDateFormatter.string(from: payment.date))"
            cell.detailTextLabel?.text = "\(payment.amount.convertToEgyptianCurrency)"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Orders"
        case 2:
            return "Payments"
        default:
            return ""
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
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
    
    @IBAction func unwindToCustomerTransactionsTableViewController(segue: UIStoryboardSegue) {
        if segue.identifier == "SaveUnwind" {
            let sourceViewConrtoller = segue.source as! AddCustomerPaymentTableViewController
            let payment = sourceViewConrtoller.payment!
            payments.append(payment)
            customer?.payments = payments
            tableView.reloadData()
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let customer = customer,
            let destinationViewController = viewController as? CustomersListTableViewController else { return }
        let indexPath = destinationViewController.selectedIndexPath!
        destinationViewController.customers[indexPath.row] = customer
        Customer.save(customers: destinationViewController.customers)
        destinationViewController.tableView.reloadData()
    }
    
}

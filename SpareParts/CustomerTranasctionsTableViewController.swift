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
    var orders = [CustomerOrder]()
    var payments = [Payment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        payments = customer?.payments?.sorted(by: <) ?? [Payment]()
        orders = customer?.orders?.sorted(by: <) ?? [CustomerOrder]()
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return orders.count
        default:
            return payments.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let addOrderPaymentCell = tableView.dequeueReusableCell(withIdentifier: "AddOrderPaymentCell", for: indexPath)
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalDueCell", for: indexPath)
            if indexPath.row == 0 {
                return addOrderPaymentCell
            } else {
                cell.textLabel?.text =
                """
                Current Balance
                \(customer?.totalDue.convertToEgyptianCurrency ?? "")
                """
                return cell
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
            let order = orders[indexPath.row]
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
            if orders.count == 0 {
                return nil
            } else {
                return "Orders"
            }
            
        case 2:
            if payments.count == 0 {
                return nil
            } else {
                return "Payments Received"
            }
            
        default:
            return ""
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
        
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 1 {
                orders.remove(at: indexPath.row)
                customer?.orders = orders
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            } else if indexPath.section == 2 {
                payments.remove(at: indexPath.row)
                customer?.payments = payments
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddPayment" {
            let destinationViewController = segue.destination as! AddEditCustomerPaymentTableViewController
            destinationViewController.title = "Add Payment"
        } else if segue.identifier == "EditPayment" {
            let destinationViewController = segue.destination as! AddEditCustomerPaymentTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let payment = payments[indexPath.row]
            destinationViewController.title = "Edit Payment"
            destinationViewController.payment = payment
        } else if segue.identifier == "AddOrder" {
            let destinationViewController = segue.destination as! AddCustomerOrderTableViewController
            destinationViewController.title = "Add Spare Parts"
        } else if segue.identifier == "ViewOrder" {
            let destinationViewController = segue.destination as! ViewEditCustomerOrderTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let order = orders[indexPath.row]
            destinationViewController.title = "\(order.orderNumber)"
            destinationViewController.order = order
        }
    }
    
    @IBAction func unwindToCustomerTransactionsTableViewController(segue: UIStoryboardSegue) {
        if segue.identifier == "SaveUnwindFromAddOrder",
            let sourceViewController = segue.source as? AddCustomerOrderTableViewController {
            let spareParts = sourceViewController.selectedSpareParts
            let order = CustomerOrder(orderNumber: CustomerOrder.generateOrderNumber(), customer: customer, spareParts: spareParts)
            orders.append(order)
            customer?.orders = orders
            tableView.reloadData()
            SparePart.save(spareParts: SparePart.all!)
        } else if segue.identifier == "SaveUnwindFromViewEditCustomerOrder" {
            guard let sourceViewController = segue.source as? ViewEditCustomerOrderTableViewController, let order = sourceViewController.order,
                let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
            orders[selectedIndexPath.row] = order
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            customer?.orders = orders
        } else if segue.identifier == "SaveUnwindFromAddEditPayment",
            let sourceViewController = segue.source as? AddEditCustomerPaymentTableViewController,
            let payment = sourceViewController.payment {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                payments[selectedIndexPath.row] = payment
                tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
                customer?.payments = payments
            } else {
                let newIndexPath = IndexPath(row: payments.count, section: 2)
                payments.append(payment)
                customer?.payments = payments
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                customer?.payments = payments
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        guard let destinationViewController = viewController as? CustomersListTableViewController else { return }
        let indexPath = destinationViewController.selectedIndexPath!
        destinationViewController.customers[indexPath.row] = customer!
        Customer.save(customers: destinationViewController.customers)
        destinationViewController.tableView.reloadData()
    }
    
}

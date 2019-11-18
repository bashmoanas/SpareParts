//
//  CustomersOrderListTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 3/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class CustomersOrderListTableViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var customerOrders = [CustomerOrder]()
    var relatedCustomerOrders: [CustomerOrder]?
    var selectedSpareParts = [SparePart: Int]()
    let year = Calendar.current.component(.year, from: Date())
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let relatedCustomerOrders = relatedCustomerOrders {
            customerOrders = relatedCustomerOrders
        } else if let savedCustomerOrders = CustomerOrder.all {
            customerOrders = savedCustomerOrders
        }
        
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
        return customerOrders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerOrderCell", for: indexPath)
        let customerOrder = customerOrders[indexPath.row]
        cell.textLabel?.text =
        """
        \(customerOrder.orderNumber)
        \(CustomerOrder.orderDateFormatter.string(from: customerOrder.date))
        """
        cell.detailTextLabel?.text =
        """
        \(customerOrder.customer?.name ?? "Not Set")
        \(customerOrder.totalDue.convertToEgyptianCurrency)
        """
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            customerOrders.remove(at: indexPath.row)
            CustomerOrder.save(customerOrders: customerOrders)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ViewCustomerOrder" {
//            selectedIndexPath = tableView.indexPathForSelectedRow
//            let customerOrder = customerOrders[selectedIndexPath!.row]
//            let destinationViewController = segue.destination as! ViewEditCustomerOrderTableViewController
//            destinationViewController.title = customerOrder.orderNumber
//            destinationViewController.customerOrder = customerOrder
//        }
//    }
    
    @IBAction func unwindToAllCustomerOrdersTableViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "AddSegue",
            let sourceViewController = segue.source as? AddCustomerOrderTableViewController else { return }
        selectedSpareParts = sourceViewController.selectedSpareParts
        let newCustomerOrder = CustomerOrder(orderNumber: "\(customerOrders.count + 1)\(year)", customer: nil, spareParts: selectedSpareParts)
        
        customerOrders.append(newCustomerOrder)
        CustomerOrder.save(customerOrders: customerOrders)
        tableView.reloadData()
    }
    
}

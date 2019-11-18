//
//  CustomersListTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 3/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class CustomersListTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var customers = [Customer]()
    var selectedIndexPath: IndexPath?
    
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
        
        if let savedCustomers = Customer.all {
            customers = savedCustomers
        }
        
        Customer.save(customers: customers)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath)
        let customer = customers[indexPath.row]
        cell.textLabel?.text = customer.name
        cell.detailTextLabel?.text = "\(customer.totalDue.convertToEgyptianCurrency)"
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            customers.remove(at: indexPath.row)
            Customer.save(customers: customers)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCustomerInfo" {
            selectedIndexPath = tableView.indexPathForSelectedRow
            let customer = customers[selectedIndexPath!.row]
            let destinationViewController = segue.destination as! CustomerTranasctionsTableViewController
            destinationViewController.customer = customer
            destinationViewController.title = customer.name
        }
    }
    
    @IBAction func unwindToAllCustomersTableViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveUnwind" else { return }
        
        guard let sourceViewController = segue.source as? AddCustomerTableViewController, let customer = sourceViewController.customer else { return }
        customers.append(customer)
        Customer.save(customers: customers)
        tableView.reloadData()
    }
    
}

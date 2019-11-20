//
//  EmployeesTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 12/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit
import Contacts

class EmployeesTableViewController: UITableViewController {
    
    var selectedContacts = [CNContact]()
    var employees = [Employee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let savedEmployees = Employee.all {
            employees = savedEmployees
            employees = employees.sorted(by: <)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath)
        let employee = employees[indexPath.row]
        cell.textLabel?.text = employee.name
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            employees.remove(at: indexPath.row)
            Employee.save(emplyees: employees)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func unwindToEmployeeTableViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveUnwind",
            let sourceViewController = segue.source as? AddEmployeeTableViewController else { return }
        selectedContacts = sourceViewController.selectedContacts
        for contact in selectedContacts {
            let name = "\(contact.givenName) \(contact.familyName)"
            let newEmployee = Employee(name: name)
            employees.append(newEmployee)
        }
        Employee.save(emplyees: employees)
        tableView.reloadData()
    }

}

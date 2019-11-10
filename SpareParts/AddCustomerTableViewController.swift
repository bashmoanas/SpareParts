//
//  AddCustomerTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 3/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class AddCustomerTableViewController: UITableViewController {
        
    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var customer: Customer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSaveButtonStatus()
    }
    
    private func updateSaveButtonStatus() {
        let customerName = customerNameTextField.text ?? ""
        
        addButton.isEnabled = !customerName.isEmpty
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonStatus()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveUnwind",
            let customerName = customerNameTextField.text {
            customer = Customer(name: customerName)
        }
    }
}

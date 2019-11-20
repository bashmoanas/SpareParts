//
//  EditPurchaseOrderDateTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 20/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class EditPurchaseOrderDateTableViewController: UITableViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var order: PurchaseOrder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let date = order?.date {
            dateLabel.text = PurchaseOrder.orderDateFormatter.string(from: date)
            datePicker.date = date
        }
        
        updateDateView()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func updateDateView() {
        dateLabel.text = PurchaseOrder.orderDateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDateView()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveUnwindFromEditPurchaseOrderDate" else { return }
        order?.date = datePicker.date
    }
    
}

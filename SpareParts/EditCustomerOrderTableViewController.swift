//
//  EditCustomerOrderTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 3/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class EditCustomerOrderTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var orderNumberTextField: UITextField!
    @IBOutlet weak var customerTextField: UITextField!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderDatePickerView: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let customers = Customer.all
    var customerOrder: CustomerOrder?
    var customer: Customer?
    var spareParts = [SparePart: Int]()
    
    let orderDateLabelViewCellIndexPath = IndexPath(row: 0, section: 2)
    let orderDatePickerViewCellIndexPath = IndexPath(row: 1, section: 2)
    
    var isDatePickerViewShown: Bool = false {
        didSet {
            orderDatePickerView.isHidden = !isDatePickerViewShown
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        let customerPicker = UIPickerView()
        customerPicker.delegate = self
        
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpace, doneButton]
        toolbar.sizeToFit()
        
        customerTextField.inputView = customerPicker
        customerTextField.inputAccessoryView = toolbar
        
        if let customerOrder = customerOrder {
            orderNumberTextField.text = customerOrder.orderNumber
            orderDatePickerView.date = customerOrder.date 
            
            if let customer = customerOrder.customer {
                customerTextField.text = "\(customer.name)"
            } else {
                customerTextField.text = ""
            }
            
            spareParts = customerOrder.spareParts
        }
        
        updateSaveButtonStatus()
        updateDateView()
    }
        
    func updateSaveButtonStatus() {
        let customerName = customerTextField.text ?? ""
        
        saveButton.isEnabled = !customerName.isEmpty
    }
    
    func updateDateView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        orderDateLabel.text = dateFormatter.string(from: orderDatePickerView.date)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return customers?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return customers?[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        customerTextField.text = customers?[row].name
        customer = customers?[row]
        updateSaveButtonStatus()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case orderDatePickerViewCellIndexPath:
            if isDatePickerViewShown {
                return 216.0
            } else {
                return 0
            }
        default:
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath {
        case orderDateLabelViewCellIndexPath:
            isDatePickerViewShown.toggle()
            
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }
    
    @objc func doneButtonTapped() {
        customerTextField.resignFirstResponder()
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateView()
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonStatus()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveUnwind" else { return }
        
        let orderNumber = orderNumberTextField.text ?? ""
        let orderDate = orderDatePickerView.date
        customerOrder = CustomerOrder(orderNumber: orderNumber, date: orderDate, customer: customer, spareParts: spareParts)
    }
}

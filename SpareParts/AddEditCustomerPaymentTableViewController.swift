//
//  AddEditCustomerPaymentTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 14/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class AddEditCustomerPaymentTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var employeeTextField: UITextField!
    @IBOutlet weak var paymentDateLabel: UILabel!
    @IBOutlet weak var paymentDatePickerView: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let employees = Employee.all
    var employee: Employee?
    var payment: CustomerPayment?
    
    let paymentDateLabelViewCellIndexPath = IndexPath(row: 1, section: 0)
    let paymentDatePickerViewCellIndexPath = IndexPath(row: 2, section: 0)
    let notesIndexPath = IndexPath(row: 0, section: 1)
    
    var isDatePickerViewShown: Bool = false {
        didSet {
            paymentDatePickerView.isHidden = !isDatePickerViewShown
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customerPicker = UIPickerView()
        customerPicker.delegate = self
        
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpace, doneButton]
        toolbar.sizeToFit()
        
        employeeTextField.inputView = customerPicker
        employeeTextField.inputAccessoryView = toolbar
        
        if let payment = payment {
            amountTextField.text = "\(payment.amount.cleaned)"
            paymentDatePickerView.date = payment.date
            employeeTextField.text = payment.collectedBy.name
            notesTextView.text = payment.notes
        }
        
        updateSaveButtonStatus()
        updateDateView()
    }
    
    func updateSaveButtonStatus() {
        let amount = amountTextField.text ?? ""
        let employee = employeeTextField.text ?? ""
        
        saveButton.isEnabled = !amount.isEmpty && !employee.isEmpty
    }
    
    func updateDateView() {
        paymentDateLabel.text = CustomerOrder.orderDateFormatter.string(from: paymentDatePickerView.date)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return employees?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return employees?[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        employeeTextField.text = employees?[row].name
        employee = employees?[row]
        updateSaveButtonStatus()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case paymentDatePickerViewCellIndexPath:
            if isDatePickerViewShown {
                return 216.0
            } else {
                return 0
            }
        case notesIndexPath:
            return 200.0
        default:
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath {
        case paymentDateLabelViewCellIndexPath:
            isDatePickerViewShown.toggle()
            
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }
    
    @objc func doneButtonTapped() {
        employeeTextField.resignFirstResponder()
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateView()
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonStatus()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "SaveUnwindFromAddEditPayment" else { return }
        
        let amount = Double(amountTextField.text ?? "") ?? 0
        let paymentDate = paymentDatePickerView.date
        let employeeName = employeeTextField.text ?? ""
        employee = employees?.filter { $0.name == employeeName}.first
        let notes = notesTextView.text ?? ""
        
        payment = CustomerPayment(amount: amount, date: paymentDate, collectedBy: employee!, notes: notes)
    }
}

//
//  AddEditNoritsuPaymentTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 20/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class AddEditNoritsuPaymentTableViewController: UITableViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var paymentDateLabel: UILabel!
    @IBOutlet weak var paymentDatePickerView: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var payment: NoritsuPayment?
    
    let paymentDateLabelViewCellIndexPath = IndexPath(row: 0, section: 1)
    let paymentDatePickerViewCellIndexPath = IndexPath(row: 1, section: 1)
    
    var isDatePickerViewShown: Bool = false {
        didSet {
            paymentDatePickerView.isHidden = !isDatePickerViewShown
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if let payment = payment {
            amountTextField.text = "\(payment.amount.cleaned)"
            paymentDatePickerView.date = payment.date
        }
        
        updateSaveButtonStatus()
        updateDateView()
    }
    
    func updateSaveButtonStatus() {
        let amount = amountTextField.text ?? ""
        
        saveButton.isEnabled = !amount.isEmpty
    }
    
    func updateDateView() {
        paymentDateLabel.text = NoritsuPayment.paymentDateFormatter.string(from: paymentDatePickerView.date)
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case paymentDatePickerViewCellIndexPath:
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
        case paymentDateLabelViewCellIndexPath:
            isDatePickerViewShown.toggle()
            
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
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
        
        guard segue.identifier == "SaveUnwindFromAddEditNoritsuPayment" else { return }
        
        let amount = Double(amountTextField.text ?? "") ?? 0
        let paymentDate = paymentDatePickerView.date
        
        payment = NoritsuPayment(amount: amount, date: paymentDate)
    }
}

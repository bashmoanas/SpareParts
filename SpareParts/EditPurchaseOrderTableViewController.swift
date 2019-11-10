//
//  EditPurchaseOrderTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 27/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class EditPurchaseOrderTableViewController: UITableViewController {
    
    @IBOutlet weak var orderNumberTextField: UITextField!
    @IBOutlet weak var invoiceNumberTextField: UITextField!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderDatePicker: UIDatePicker!
    @IBOutlet weak var orderDatePickerView: UIDatePicker!
    @IBOutlet weak var courierChargeJPYTextField: UITextField!
    @IBOutlet weak var jpyValueTextField: UITextField!
    @IBOutlet weak var totalCustomTextField: UITextField!
    @IBOutlet weak var vatTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let orderDateLabelViewCellIndexPath = IndexPath(row: 0, section: 1)
    let orderDatePickerViewCellIndexPath = IndexPath(row: 1, section: 1)
    
    var isDatePickerViewShown: Bool = false {
        didSet {
            orderDatePickerView.isHidden = !isDatePickerViewShown
        }
    }

    
    var purchaseOrder: PurchaseOrder?
    var spareParts = [SparePart: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        if let purchaseOrder = purchaseOrder {
            orderNumberTextField.text = purchaseOrder.orderNumber
            orderDatePickerView.date = purchaseOrder.date 
            
            if let invoiceNumber = purchaseOrder.invoiceNumber,
                let courierCharge = purchaseOrder.courierChargeJPY,
                let jpyValue = purchaseOrder.jpyValue, let totalCustom = purchaseOrder.totalCustom,
                let vat = purchaseOrder.vat {
                invoiceNumberTextField.text = "\(invoiceNumber)"
                courierChargeJPYTextField.text = "\(courierCharge)"
                jpyValueTextField.text = "\(jpyValue)"
                totalCustomTextField.text = "\(totalCustom)"
                vatTextField.text = "\(vat)"
            } else {
                invoiceNumberTextField.text = ""
                courierChargeJPYTextField.text = ""
                jpyValueTextField.text = ""
                totalCustomTextField.text = ""
                vatTextField.text = ""
            }
            
            orderDateLabel.text = PurchaseOrder.orderDateFormatter.string(from: purchaseOrder.date)
            spareParts = purchaseOrder.spareParts
        }
        
        updateSaveButtonStatus()
    }
    
    func updateSaveButtonStatus() {
        let orderNumber = orderNumberTextField.text ?? ""
        let invoiceNumber = invoiceNumberTextField.text ?? ""
        let courierCharge = courierChargeJPYTextField.text ?? ""
        let jpyValue  = jpyValueTextField.text ?? ""
        let totalCustom = totalCustomTextField.text ?? ""
        let vat = vatTextField.text ?? ""
        
        saveButton.isEnabled = !orderNumber.isEmpty && !invoiceNumber.isEmpty && !courierCharge.isEmpty && !jpyValue.isEmpty && !totalCustom.isEmpty && !vat.isEmpty
    }
    
    func updateDateView() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        orderDateLabel.text = dateFormatter.string(from: orderDatePickerView.date)
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
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonStatus()
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateView()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveUnwind" else { return }
        
        let orderNumber = orderNumberTextField.text ?? ""
        let invoiceNumber = invoiceNumberTextField.text ?? ""
        let courierCharge = courierChargeJPYTextField.text ?? ""
        let jpyValue  = jpyValueTextField.text ?? ""
        let totalCustom = totalCustomTextField.text ?? ""
        let vat = vatTextField.text ?? ""
        let orderDate = orderDatePickerView.date
        
        if let invoiceNumber = Int(invoiceNumber),
            let courierCharge = Double(courierCharge),
            let jpyValue = Double(jpyValue),
            let totalCustom = Double(totalCustom),
            let vat = Double(vat) {
            purchaseOrder = PurchaseOrder(orderNumber: orderNumber, date: orderDate, invoiceNumber: invoiceNumber, spareParts: spareParts, courierChargeJPY: courierCharge, jpyValue: jpyValue, totalCustom: totalCustom, vat: vat)
        }
        
        
    }

}

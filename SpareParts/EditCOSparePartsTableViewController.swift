//
//  EditCOSparePartsTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 4/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class EditCOSparePartsTableViewController: UITableViewController {
    
    @IBOutlet weak var partNumberLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var newSalePriceTextField: UITextField!
    @IBOutlet weak var quantitystepper: UIStepper!
    @IBOutlet weak var totalDueLabel: UILabel!
    
    var order: CustomerOrder?
    var sparePart: SparePart?
    var quantity: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpace, doneButton]
        toolbar.sizeToFit()
        
        newSalePriceTextField.inputAccessoryView = toolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let customerOrder = order,
            let sparePart = sparePart {
            partNumberLabel.text = sparePart.partNumber
            quantity = customerOrder.spareParts[sparePart]
            quantitystepper.minimumValue = 1
            quantitystepper.maximumValue = Double(sparePart.currentStock) + Double(quantity ?? 1)
            updateQuantityLabel()
            if let salePrice = sparePart.alternativeSalePrice {
                currentPriceLabel.text = "\(salePrice.convertToEgyptianCurrency)"
            } else {
                currentPriceLabel.text = "\(sparePart.salePrice.convertToEgyptianCurrency)"
            }
            
            if let otherPrice = sparePart.otherSalePrice {
                newSalePriceTextField.text = "\(otherPrice.cleaned)"
            }
            
            updateTotalDue()
        }
    }
    
    func updateQuantityLabel() {
        quantitystepper.value = Double(quantity ?? 1)
        quantityLabel.text = "\(quantity!)"
    }
    
    func updateTotalDue() {
        var price = 0.0
        let currentQuantity = Double(quantity ?? 1)
        
        if let sparePart = sparePart {
            if let otherPrice = sparePart.otherSalePrice {
                price = otherPrice
            } else if let alternativePrice = sparePart.alternativeSalePrice {
                price = alternativePrice
            } else {
                price = sparePart.salePrice
            }
        }
            
                
        totalDueLabel.text = "\((price * currentQuantity).convertToEgyptianCurrency)"
        
    }
    
    @IBAction func otherSalePriceTextField(_ sender: UITextField) {
        if let text = sender.text {
            sparePart?.otherSalePrice = Double(text)
        }
        
        updateTotalDue()
    }
    
    @objc func doneButtonTapped() {
        newSalePriceTextField.resignFirstResponder()
        updateTotalDue()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let stepperValue = sender.value
        quantity = Int(stepperValue)
        updateQuantityLabel()
        updateTotalDue()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "SaveUnwindFromEditCOSpareParts" else { return }
        quantity = Int(quantitystepper.value) 
    }
    
}

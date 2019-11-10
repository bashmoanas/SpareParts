//
//  AddEditSparePartTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 21/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class AddSparePartTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var partNumberTextField: UITextField!
    @IBOutlet weak var priceInJPYTextField: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var savedSpareParts = SparePart.all
    var sparePart: SparePart?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sparePart = sparePart {
            detailsTextField.text = "\(sparePart.details)"
            partNumberTextField.text = "\(sparePart.partNumber)"
            priceInJPYTextField.text = "\(sparePart.priceInJPY.cleaned)"
        }
        
        updateSaveButtonStatus()
    }
    
    private func updateSaveButtonStatus() {
        let details = detailsTextField.text ?? ""
        let partNumber = partNumberTextField.text ?? ""
        let priceInJPY = priceInJPYTextField.text ?? ""
        
        addButton.isEnabled = !details.isEmpty && !partNumber.isEmpty && !priceInJPY.isEmpty
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let text = textField.text
        
        if let spareParts = savedSpareParts {
            for sparePart in spareParts {
                if sparePart.partNumber == text {
                    addButton.isEnabled = false
                    return false
                }
            }
        }
        return true
        
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonStatus()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveUnwind",
            let details = detailsTextField.text,
            let partNumber = partNumberTextField.text,
            let priceInJPY = Double(priceInJPYTextField.text ?? "") {
            sparePart = SparePart(details: details, partNumber: partNumber, priceInJPY: priceInJPY, alternativeSalePrice: nil, otherSalePrice: nil)
        }
    }
}

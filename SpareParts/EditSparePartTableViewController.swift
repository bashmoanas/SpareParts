//
//  EditSparePartTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 23/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class EditSparePartTableViewController: UITableViewController {
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var partNumberTextField: UITextField!
    @IBOutlet weak var priceInJPYTextField: UITextField!
    @IBOutlet weak var automaticSalePriceLabel: UILabel!
    @IBOutlet weak var newPriceTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var sparePart: SparePart?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sparePart = sparePart {
            descriptionTextField.text = sparePart.details
            partNumberTextField.text = sparePart.partNumber
            priceInJPYTextField.text = "\(sparePart.priceInJPY.cleaned)"
            automaticSalePriceLabel.text = "\(sparePart.salePrice.convertToEgyptianCurrency)"
            newPriceTextField.text = "\(sparePart.alternativeSalePrice?.cleaned ?? "")"
        }
        
        updateSaveButtonStatus()
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func updateSaveButtonStatus() {
        let descriptionText = descriptionTextField.text ?? ""
        let partNumber = partNumberTextField.text ?? ""
        let priceInJPY  = priceInJPYTextField.text ?? ""
        
        saveButton.isEnabled = !descriptionText.isEmpty && !partNumber.isEmpty && !priceInJPY.isEmpty
    }
        
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonStatus()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveUnwind" else { return }
        
        let descriptionText = descriptionTextField.text ?? ""
        let partNumber = partNumberTextField.text ?? ""
        let priceInJPY = Double(priceInJPYTextField.text ?? "") ?? 0
        let alternativePrice = Double(newPriceTextField.text ?? "")
        
        sparePart = SparePart(details: descriptionText, partNumber: partNumber, priceInJPY: priceInJPY, alternativeSalePrice: alternativePrice, otherSalePrice: nil)
    }
    
}

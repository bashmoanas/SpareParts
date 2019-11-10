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
    @IBOutlet weak var quantitystepper: UIStepper!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var newSalePriceTextField: UITextField!
    
    var customerOrder: CustomerOrder?
    var sparePart: SparePart?
    var quantity: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let customerOrder = customerOrder,
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
        }
    }
    
    func updateQuantityLabel() {
        quantitystepper.value = Double(quantity ?? 1)
        quantityLabel.text = "\(quantity!)"
    }
    @IBAction func otherSalePriceTextField(_ sender: UITextField) {
        if let text = sender.text {
            sparePart?.otherSalePrice = Double(text)
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let stepperValue = sender.value
        quantity = Int(stepperValue)
        updateQuantityLabel()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

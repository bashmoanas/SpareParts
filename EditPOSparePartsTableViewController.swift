//
//  EditPOSparePartsTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 28/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class EditPOSparePartsTableViewController: UITableViewController {
    
    @IBOutlet weak var partNumberLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var purchasePriceLabel: UILabel!
    @IBOutlet weak var quantitystepper: UIStepper!
    @IBOutlet weak var totalDueLabel: UILabel!
    
    var order: PurchaseOrder?
    var sparePart: SparePart?
    var quantity: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let purchaseOrder = order,
            let sparePart = sparePart {
            partNumberLabel.text = sparePart.partNumber
            quantity = purchaseOrder.spareParts[sparePart]
            quantitystepper.minimumValue = 1
            updateQuantityLabel()
            purchasePriceLabel.text = "\(sparePart.priceInJPY.convertToJapaneseCurrency)"
            
            updateTotalDue()
        }
    }
    
    func updateQuantityLabel() {
        quantitystepper.value = Double(quantity ?? 1)
        quantityLabel.text = "\(quantity!)"
    }
    
    func updateTotalDue() {
        let currentQuantity = Double(quantity ?? 1)
        if let purchasePrice = sparePart?.priceInJPY {
            totalDueLabel.text = "\((purchasePrice * currentQuantity).convertToJapaneseCurrency)"
        }
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
        
        guard segue.identifier == "SaveUnwindFromEditPOSpareParts" else { return }
        quantity = Int(quantitystepper.value)
    }
    
}

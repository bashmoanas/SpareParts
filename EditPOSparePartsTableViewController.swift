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
    @IBOutlet weak var quantitystepper: UIStepper!
    
    var purchaseOrder: PurchaseOrder?
    var sparePart: SparePart?
    var quantity: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let purchaseOrder = purchaseOrder,
            let sparePart = sparePart {
            partNumberLabel.text = sparePart.partNumber
            quantity = purchaseOrder.spareParts[sparePart]
            updateQuantityLabel()
        }
    }
    
    func updateQuantityLabel() {
        quantitystepper.value = Double(quantity ?? 1)
        quantityLabel.text = "\(quantity!)"
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

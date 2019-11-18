//
//  CustomerOrderCell.swift
//  SpareParts
//
//  Created by Anas Bashandy on 14/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

protocol CustomerOrderCellDelegate: class {
    func set(quantity: Int, sender: CustomerOrderCell)
}

class CustomerOrderCell: UITableViewCell {
    
    @IBOutlet weak var partNumberLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var quantityLabel: UILabel!
    
    weak var delegate: CustomerOrderCellDelegate?
    
    var quantitity = 1
                        
    func update(with sparePart: SparePart) {
        partNumberLabel.text = sparePart.partNumber
        quantityLabel.text = "\(stepper.value.cleaned)"
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        quantityLabel.text = "\(sender.value.cleaned)"
        quantitity = Int(sender.value.cleaned) ?? 0
        delegate?.set(quantity: Int(sender.value), sender: self)
    }
    
}

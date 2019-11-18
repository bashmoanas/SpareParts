//
//  DatePickerCell.swift
//  SpareParts
//
//  Created by Anas Bashandy on 18/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class DatePickerCell: UITableViewCell {
    
    @IBOutlet weak var orderDatePicker: UIDatePicker!
    
    var isDatePickerShown = false {
        didSet {
            orderDatePicker.isHidden = !isDatePickerShown
        }
    }
    
}

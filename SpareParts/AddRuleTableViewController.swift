//
//  AddEditRuleTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 16/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class AddRuleTableViewController: UITableViewController {
    
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var profitTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var rule: Rule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rule = rule {
            costTextField.text = "\(rule.cost.cleaned)"
            profitTextField.text = "\(rule.profit.cleaned)"
        }
        
        updateSaveButtonStatus()
    }
    
    private func updateSaveButtonStatus() {
        let cost = costTextField.text ?? ""
        let profit = profitTextField.text ?? ""
        
        saveButton.isEnabled = !cost.isEmpty && !profit.isEmpty
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonStatus()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveUnwind",
            let cost = Double(costTextField.text ?? ""),
            let profit = Double(profitTextField.text ?? "") else { return }
        
        rule = Rule(cost: cost, profit: profit)
    }

}

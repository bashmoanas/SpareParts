//
//  PriceCalculatorTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 16/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class PriceCalculatorTableViewController: UITableViewController {
    
    @IBOutlet weak var costFactorTextField: UITextField!
    @IBOutlet weak var noRuleProfitTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var costFactor: Double?
    var noRuleProfit: Double?
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let costFactor = costFactor,
            let noRuleProfit = noRuleProfit else { return }
        costFactorTextField.text = "\(costFactor.cleaned)"
        noRuleProfitTextField.text = "\(noRuleProfit.cleaned)"
        
        updateSaveButtonStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        costFactorTextField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    private func updateSaveButtonStatus() {
        let costFactor = costFactorTextField.text ?? ""
        let noRuleProfit = noRuleProfitTextField.text ?? ""
        
        saveButton.isEnabled = !costFactor.isEmpty && !noRuleProfit.isEmpty
    }

    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonStatus()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveSegue" else { return }
        
        guard let costFactorDouble = Double(costFactorTextField.text ?? ""),
            let noRuleProfitDouble = Double(noRuleProfitTextField.text ?? "") else { return }
        
        costFactor = costFactorDouble
        noRuleProfit = noRuleProfitDouble
        
        userDefaults.set(costFactor, forKey: "CostFactor")
        userDefaults.set(noRuleProfit, forKey: "NoRuleProfit")
    }
    
}

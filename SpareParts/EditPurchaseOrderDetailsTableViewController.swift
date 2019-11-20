//
//  ViewPurchaseOrderTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 27/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class EditPurchaseOrderDetailsTableViewController: UITableViewController {
    
    @IBOutlet weak var invoiceNumberTextField: UITextField!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var courierChargeInJPYTextField: UITextField!
    @IBOutlet weak var japaneseYenValueTextField: UITextField!
    
    @IBOutlet weak var totalCustomsTextField: UITextField!
    @IBOutlet weak var vatTextField: UITextField!
    
    @IBOutlet weak var fobJPYLabel: UILabel!
    @IBOutlet weak var cifJPYLabel: UILabel!
    @IBOutlet weak var fobEGPLabel: UILabel!
    @IBOutlet weak var cifEGPLabel: UILabel!
    @IBOutlet weak var customWithoutVATLabel: UILabel!
    @IBOutlet weak var fotcolorLabel: UILabel!
    @IBOutlet weak var totalCostWithoutVATLabel: UILabel!
    @IBOutlet weak var costFactorLabel: UILabel!
    
    var order: PurchaseOrder?
    
    let dateLabelIndexPath = IndexPath(row: 0, section: 0)
    let datePickerIndexPath = IndexPath(row: 1, section: 0)
    var isdatePickerHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpace, doneButton]
        toolbar.sizeToFit()
        
        invoiceNumberTextField.inputAccessoryView = toolbar
        courierChargeInJPYTextField.inputAccessoryView = toolbar
        japaneseYenValueTextField.inputAccessoryView = toolbar
        totalCustomsTextField.inputAccessoryView = toolbar
        vatTextField.inputAccessoryView = toolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let purchaseOrder = order {
            fobJPYLabel.text = "\(purchaseOrder.fobtotalCostJPY.convertToJapaneseCurrency)"
            dateLabel.text = "\(PurchaseOrder.orderDateFormatter.string(from: order?.date ?? Date()))"
            datePicker.date = order?.date ?? Date()
            
            if let invoiceNumber = purchaseOrder.invoiceNumber,
                let courierCharge = purchaseOrder.courierChargeJPY,
                let jpyValue = purchaseOrder.jpyValue,
                let totalCustom = purchaseOrder.totalCustom,
                let vat = purchaseOrder.vat {
                invoiceNumberTextField.text = "\(invoiceNumber)"
                courierChargeInJPYTextField.text = "\(courierCharge.convertToJapaneseCurrency)"
                japaneseYenValueTextField.text = "\(jpyValue.cleaned)"
                totalCustomsTextField.text = "\(totalCustom.convertToEgyptianCurrency)"
                vatTextField.text = "\(vat.convertToEgyptianCurrency)"
                
                fobJPYLabel.text = "\(purchaseOrder.fobtotalCostJPY)"
                cifJPYLabel.text = "\(purchaseOrder.ciftotalCostJPY)"
                fobEGPLabel.text = "\(purchaseOrder.fobEGP)"
                cifEGPLabel.text = "\(purchaseOrder.cifEGP)"
                customWithoutVATLabel.text = "\(purchaseOrder.totalCostWithoutVAT)"
                fotcolorLabel.text = "\(purchaseOrder.fotocolor)"
                totalCostWithoutVATLabel.text = "\(purchaseOrder.totalCostWithoutVAT)"
                costFactorLabel.text = "\(purchaseOrder.costFactor)"
            } else {
                invoiceNumberTextField.placeholder = "Not Set"
                courierChargeInJPYTextField.placeholder = "Not Set"
                japaneseYenValueTextField.placeholder = "Not Set"
                totalCustomsTextField.placeholder = "Not Set"
                vatTextField.placeholder = "Not Set"
                
                cifJPYLabel.text = "..."
                fobEGPLabel.text = "..."
                cifEGPLabel.text = "..."
                customWithoutVATLabel.text = "..."
                fotcolorLabel.text = "..."
                totalCostWithoutVATLabel.text = "..."
                costFactorLabel.text = "..."
            }
        }
        
        updateDateView()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return isdatePickerHidden ? 0 : 216
        default:
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath {
        case dateLabelIndexPath:
            isdatePickerHidden.toggle()
            
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
        updatePurchaseOrderLabels()
    }
    
    func updatePurchaseOrderLabels() {
        guard order != nil else { return }
        let cifJPY = order?.ciftotalCostJPY.convertToJapaneseCurrency ?? ""
        let fobEGP = order?.fobEGP.convertToEgyptianCurrency ?? ""
        let cifEGP = order?.cifEGP.convertToEgyptianCurrency ?? ""
        let customsWithoutVAT = order?.customWithoutVAT.convertToEgyptianCurrency ?? ""
        let fotocolor = order?.fotocolor.convertToEgyptianCurrency ?? ""
        let totalCostWithoutVAT = order?.totalCostWithoutVAT.convertToEgyptianCurrency ?? ""
        let costFactor = order?.costFactor.cleaned ?? ""
        
        cifJPYLabel.text = "\(cifJPY)"
        fobEGPLabel.text = "\(fobEGP)"
        cifEGPLabel.text = "\(cifEGP)"
        customWithoutVATLabel.text = "\(customsWithoutVAT)"
        fotcolorLabel.text = "\(fotocolor)"
        totalCostWithoutVATLabel.text = "\(totalCostWithoutVAT)"
        costFactorLabel.text = "\(costFactor)"
    }
    
    func updateDateView() {
        dateLabel.text = PurchaseOrder.orderDateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDateView()
    }
    
    @IBAction func textFieldEditingEnded(_ sender: UITextField) {
        switch sender {
        case courierChargeInJPYTextField:
            let courierChargeJPY = courierChargeInJPYTextField.text ?? ""
            order?.courierChargeJPY = Double(courierChargeJPY)
        case japaneseYenValueTextField:
            let japaneseYenValue = japaneseYenValueTextField.text ?? ""
            order?.jpyValue = Double(japaneseYenValue)
        case totalCustomsTextField:
            let totalCustoms = totalCustomsTextField.text ?? ""
            order?.totalCustom = Double(totalCustoms)
        case vatTextField:
            let vat = vatTextField.text ?? ""
            order?.vat = Double(vat)
        default:
            break
        }
        
        updatePurchaseOrderLabels()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveUnwindFromEditPurchasaeOrderDetails" {
            order?.date = datePicker.date
            order?.invoiceNumber = Int(invoiceNumberTextField.text ?? "")
            order?.courierChargeJPY = Double(courierChargeInJPYTextField.text ?? "")
            order?.jpyValue = Double(japaneseYenValueTextField.text ?? "")
            order?.totalCustom = Double(totalCustomsTextField.text ?? "")
            order?.vat = Double(vatTextField.text ?? "")
        }
    }
}

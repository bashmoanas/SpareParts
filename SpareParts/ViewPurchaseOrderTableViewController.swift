//
//  ViewPurchaseOrderTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 27/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class ViewPurchaseOrderTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var purchaseOrderNumberLabel: UILabel!
    @IBOutlet weak var invoiceNumberLabel: UILabel!
    @IBOutlet weak var fobJPYLabel: UILabel!
    @IBOutlet weak var courierChargeJPYLabel: UILabel!
    @IBOutlet weak var cifJPYLabel: UILabel!
    @IBOutlet weak var jpyValueLabel: UILabel!
    @IBOutlet weak var fobEGPLabel: UILabel!
    @IBOutlet weak var cifEGPLabel: UILabel!
    @IBOutlet weak var totalCustomLabel: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var customWithoutVATLabel: UILabel!
    @IBOutlet weak var fotcolorLabel: UILabel!
    @IBOutlet weak var totalCostWithoutVATLabel: UILabel!
    @IBOutlet weak var costFactorLabel: UILabel!
    
    var purchaseOrder: PurchaseOrder?
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let purchaseOrder = purchaseOrder {
            purchaseOrderNumberLabel.text =
            """
            \(purchaseOrder.orderNumber)
            \(PurchaseOrder.orderDateFormatter.string(from: purchaseOrder.date))
            """
            fobJPYLabel.text = "\(purchaseOrder.fobtotalCostJPY.convertToJapaneseCurrency)"
            cifJPYLabel.text = "\(purchaseOrder.ciftotalCostJPY.convertToJapaneseCurrency)"
            fobEGPLabel.text = "\(purchaseOrder.fobEGP.convertToEgyptianCurrency)"
            cifEGPLabel.text = "\(purchaseOrder.cifEGP.convertToEgyptianCurrency)"
            customWithoutVATLabel.text = "\(purchaseOrder.customWithoutVAT.convertToEgyptianCurrency)"
            fotcolorLabel.text = "\(purchaseOrder.fotocolor.convertToEgyptianCurrency)"
            totalCostWithoutVATLabel.text = "\(purchaseOrder.totalCostWithoutVAT.convertToEgyptianCurrency)"
            costFactorLabel.text = "\(purchaseOrder.costFactor.cleaned)"
            
            if let invoiceNumber = purchaseOrder.invoiceNumber,
                let courierCharge = purchaseOrder.courierChargeJPY,
                let jpyValue = purchaseOrder.jpyValue,
                let totalCustom = purchaseOrder.totalCustom,
                let vat = purchaseOrder.vat {
                invoiceNumberLabel.text = "\(invoiceNumber)"
                courierChargeJPYLabel.text = "\(courierCharge.convertToJapaneseCurrency)"
                jpyValueLabel.text = "\(jpyValue.cleaned)"
                totalCustomLabel.text = "\(totalCustom.convertToEgyptianCurrency)"
                vatLabel.text = "\(vat.convertToEgyptianCurrency)"
            } else {
                invoiceNumberLabel.text = "Not Set"
                courierChargeJPYLabel.text = "Not Set"
                jpyValueLabel.text = "Not Set"
                totalCustomLabel.text = "Not Set"
                vatLabel.text = "Not Set"
            }
        }
        
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditPurchaseOrder" {
            let destinationViewController = segue.destination as! EditPurchaseOrderTableViewController
            destinationViewController.title = purchaseOrder?.orderNumber
            destinationViewController.purchaseOrder = purchaseOrder
        } else if segue.identifier == "ShowPOSpareParts", let purchaseOrder = purchaseOrder {
            let destinationViewController = segue.destination as! ShowPOSparePartsTableViewController
            destinationViewController.purchaseOrder = purchaseOrder
        }
    }
    
    @IBAction func unwindToViewPurchaseOrder(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveUnwind" else { return }
        if let sourceViewController = segue.source as? EditPurchaseOrderTableViewController {
            purchaseOrder = sourceViewController.purchaseOrder
        } else if let sourceViewController = segue.source as? ShowPOSparePartsTableViewController {
            purchaseOrder = sourceViewController.purchaseOrder
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let purchaseOrder = purchaseOrder,
            let destinationViewController = viewController as? PurchaseOrdersListTableViewController else { return }
        let indexPath = destinationViewController.selectedIndexPath!
        destinationViewController.purchaseOrders[indexPath.row] = purchaseOrder
        PurchaseOrder.save(purchaseOrders: destinationViewController.purchaseOrders)
        destinationViewController.tableView.reloadData()
    }
    
}

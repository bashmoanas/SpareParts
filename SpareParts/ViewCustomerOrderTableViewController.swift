//
//  ViewCustomerOrderTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 3/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class ViewCustomerOrderTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var customerOrderNumberLabel: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var totalDueLabel: UILabel!
    
    var customerOrder: CustomerOrder?
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let customerOrder = customerOrder {
            customerOrderNumberLabel.text =
            """
            \(customerOrder.orderNumber)
            \(CustomerOrder.orderDateFormatter.string(from: customerOrder.date))
            """
            customerLabel.text = customerOrder.customer?.name ?? "Not Set"
            totalDueLabel.text = "\(customerOrder.totalDue.convertToEgyptianCurrency)"
            
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditCustomerOrder" {
            let destinationViewController = segue.destination as! EditCustomerOrderTableViewController
            destinationViewController.title = customerOrder?.orderNumber
            destinationViewController.customerOrder = customerOrder
        } else if segue.identifier == "ShowCOSpareParts", let customerOrder = customerOrder {
            let destinationViewController = segue.destination as! ShowCOSparePartsTableViewController
            let title = UILabel()
            title.numberOfLines = 0
            title.textAlignment = .center
            title.text =
            """
            \(customerOrder.customer?.name ?? "Not Set")
            \(CustomerOrder.orderDateFormatter.string(from: customerOrder.date))
            """
            destinationViewController.navigationItem.titleView = title
            destinationViewController.customerOrder = customerOrder
        }
    }
    
    @IBAction func unwindToViewCustomerOrder(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveUnwind" else { return }
        if let sourceViewController = segue.source as? EditCustomerOrderTableViewController {
            customerOrder = sourceViewController.customerOrder
        } else if let sourceViewController = segue.source as? ShowCOSparePartsTableViewController {
            customerOrder = sourceViewController.customerOrder

        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let customerOrder = customerOrder,
            let destinationViewController = viewController as? CustomersOrderListTableViewController else { return }
        let indexPath = destinationViewController.selectedIndexPath!
        destinationViewController.customerOrders[indexPath.row] = customerOrder
        CustomerOrder.save(customerOrders: destinationViewController.customerOrders)
        destinationViewController.tableView.reloadData()
    }
    
}

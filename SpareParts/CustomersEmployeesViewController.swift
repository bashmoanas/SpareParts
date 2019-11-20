//
//  CustomersEmployeesViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 20/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class CustomersEmployeesViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "main", bundle: Bundle.main)
        let customersViewController = storyboard.instantiateViewController(withIdentifier: "CustomersViewController")
    }
    
    func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

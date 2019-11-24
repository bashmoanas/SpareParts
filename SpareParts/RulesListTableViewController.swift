//
//  RulesListTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 16/10/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit

class RulesListTableViewController: UITableViewController {
    
    var rules = [Rule]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedRules = Rule.loadSavedRules() {
            rules = savedRules
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rules = rules.sorted(by: <)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rules.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RuleCell", for: indexPath)
        let rule = rules[indexPath.row]
        cell.textLabel?.text = rule.description
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            rules.remove(at: indexPath.row)
            Rule.save(rules)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "EditRule" else { return }
        
        let indexPath = tableView.indexPathForSelectedRow!
        let rule = rules[indexPath.row]
        let destinationViewController = segue.destination as! AddRuleTableViewController
        destinationViewController.rule = rule
    }
    
    @IBAction func unwindToAllRulesTableViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveUnwind",
            let sourceViewController = segue.source as? AddRuleTableViewController,
            let rule = sourceViewController.rule else { return }
                
        if let indexPath = tableView.indexPathForSelectedRow {
            rules[indexPath.row] = rule
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: rules.count, section: 0)
            rules.append(rule)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        Rule.save(rules)
    }
}

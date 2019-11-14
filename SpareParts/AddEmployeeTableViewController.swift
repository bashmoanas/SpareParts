//
//  AddEmployeeTableViewController.swift
//  SpareParts
//
//  Created by Anas Bashandy on 12/11/19.
//  Copyright © 2019 Anas Bashandy. All rights reserved.
//

import UIKit
import Contacts

class AddEmployeeTableViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var contacts = [CNContact]()
    var selectedContacts = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isEditing = true
        
        let store = CNContactStore()
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        switch authorizationStatus {
        case .authorized:
            retrieveContacts(from: store)
        default:
            store.requestAccess(for: .contacts) { (didAuthoriza, erroe) in
                if didAuthoriza {
                    self.retrieveContacts(from: store)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for _ in contacts {
            contacts.removeAll { (contact) -> Bool in
                contact.givenName == ""
            }
        }
    }
    
    private func retrieveContacts(from store: CNContactStore) {
        let containerID = store.defaultContainerIdentifier()
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerID)
        let keysToFetch = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
        ]
        
        contacts = try! store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch).sorted(by: <)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = contacts[indexPath.row]
        cell.textLabel?.text =
        """
        \(contact.givenName) \(contact.familyName)
        """
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                let contact = self.contacts[indexPath.row]
                selectedContacts.append(contact)
            }
        }
    }
    
}

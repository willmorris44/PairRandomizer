//
//  PairListTableViewController.swift
//  PairRandomizer
//
//  Created by Will morris on 6/14/19.
//  Copyright © 2019 devmtn. All rights reserved.
//

import UIKit

class PairListTableViewController: UITableViewController {
    
    var dic = [String : [Person]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        PersonController.shared.loadFromFirestore {
            self.tableView.reloadData()
        }
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        presentAddPersonAlert()
    }
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        PersonController.shared.randomize()
        generateDic()
        reloadData()
    }
    
    // MARK: - Methods
    
    func generateDic() {
        var token = 1
        for person in PersonController.shared.personArray {
            
            let key = "Group \(token)"
            
            if let _ = dic[key] {
                if dic[key]?.count == 2 {
                    token += 1
                    continue
                } else {
                    dic[key]?.append(person)
                }
            } else {
                dic[key] = []
                dic[key]?.append(person)
            }
        }
    }
    
    func presentAddPersonAlert() {
        let alert = UIAlertController(title: "Add Person", message: "Add someone new to the list", preferredStyle: .alert)
        alert.addTextField()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let name = alert.textFields?.first?.text {
                PersonController.shared.createPerson(name: name)
                self.reloadData()
            } else {
                self.presentErrorAlert()
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func presentErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Please enter a name", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(okayAction)
        present(alert, animated: true)
    }
    
    func reloadData () {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if PersonController.shared.personArray.count % 2 == 0 {
            return PersonController.shared.personArray.count / 2
        } else {
            return (PersonController.shared.personArray.count + 1) / 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        
        let person = PersonController.shared.personArray[indexPath.row]
        
        
        return cell
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
}

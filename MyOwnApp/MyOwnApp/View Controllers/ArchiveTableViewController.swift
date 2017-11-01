//
//  ArchiveTableViewController.swift
//  MyOwnApp
//
//  Created by Fhict on 01/11/2017.
//  Copyright © 2017 Fhict. All rights reserved.
//

import UIKit

class ArchiveTableViewController: UITableViewController {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.solvedTasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        let task = delegate.solvedTasks[indexPath.row]
        cell.nameLabel?.text = task.taskName
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mySegue" {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                let destVC = segue.destination as! ArchiveViewController
                destVC.nameText = delegate.solvedTasks[indexPath.row].taskName
                destVC.answerText = delegate.solvedTasks[indexPath.row].correctAnswer
                destVC.descriptionText = delegate.solvedTasks[indexPath.row].taskDescription
            }
        }
    }
    

}

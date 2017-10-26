//
//  TaskViewController.swift
//  MyOwnApp
//
//  Created by Fhict on 26/10/2017.
//  Copyright © 2017 Fhict. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TaskViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var answerField: UITextField!
    
    
    @IBAction func submitButton(_ sender: UIButton) {
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

       ref = Database.database().reference()
        ref?.child("PinData").child("pin1").observeSingleEvent(of: .value, with: { (snapshot) in
            
        let value = snapshot.value as? NSDictionary
        self.nameLabel.text = value?["taskName"] as? String
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

//
//  ArchiveViewController.swift
//  MyOwnApp
//
//  Created by Fhict on 01/11/2017.
//  Copyright © 2017 Fhict. All rights reserved.
//

import UIKit

class ArchiveViewController: UIViewController {
    
    var nameText: String?
    var answerText: String?
    var descriptionText: String?
    
    // MARK: -  IBOutlets
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameTextView.text = nameText
        answerTextView.text = answerText
        descriptionTextView.text = descriptionText
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    

}

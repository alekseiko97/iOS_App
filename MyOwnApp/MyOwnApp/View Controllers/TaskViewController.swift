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
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: Outlets
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var answerField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextView.text = delegate.taskName
        self.delegate.isCompleted = false
        
    }
    
    func showAlertSuccess(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) {  (_) -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        let userAnswer = self.answerField.text
        let expectedAnswer = self.delegate.correctAnswer
        if userAnswer == expectedAnswer
        {
            let nrOfPoints = self.delegate.receivedPoints
            self.showAlertSuccess(title: "Congratulations", message: "Your answer is correct! You've received \(String(describing: nrOfPoints)) points")
            self.delegate.score += nrOfPoints!
            self.delegate.isCompleted = true
        }
        else
        {
            self.showAlert(title: "Oops", message: "Your answer is not correct. Please try again.")
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

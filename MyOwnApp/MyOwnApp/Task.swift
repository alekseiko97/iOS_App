//
//  Task.swift
//  MyOwnApp
//
//  Created by Fhict on 01/11/2017.
//  Copyright © 2017 Fhict. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

struct TaskStructure
{
    static let taskName = "taskName"
    static let taskDescription = "taskDescription"
    static let identifier = "identifier"
    static let correctAnswer = "correctAnswer"
    static let receivedPoints = "receivedPoints"
}

class Task: NSObject
{
    var taskName: String
    var taskDescription: String
    var identifier: Int
    var correctAnswer: String
    var receivedPoints: Int
    
    init(taskName: String, taskDescription: String, identifier: Int, correctAnswer: String, receivedPoints: Int) {
        
        self.taskName = taskName
        self.taskDescription = taskDescription
        self.identifier = identifier
        self.correctAnswer = correctAnswer
        self.receivedPoints = receivedPoints
        
    }
    
    
    
}

/* class TaskArray: NSObject
{
    var tasks: [Task] = []
    var ref: DatabaseReference!
    
    override init()
    {
        super.init()
        ref = Database.database().reference()
        getAllData()
    }
    
    func getAllData()
    {
        ref?.child("PinData").childByAutoId().observeSingleEvent(of: .value, with: {(snapshot) in
         let value = snapshot.value as? NSDictionary
            let taskName = value?["taskName"] as? String
            let taskDescription = value?["taskDescription"] as? String
            let identifier = value?["id"] as? Int
            let correctAnswer = value?["correctAnswer"] as? String
            let receivedPoints = value?["receivedPoints"] as! Int
            self.tasks.append(Task(taskName: taskName!, taskDescription: taskDescription!, identifier: identifier!, correctAnswer: correctAnswer!, receivedPoints: receivedPoints))
            
        } )
    }
} */

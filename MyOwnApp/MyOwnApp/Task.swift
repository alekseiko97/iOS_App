//
//  Task.swift
//  MyOwnApp
//
//  Created by Fhict on 01/11/2017.
//  Copyright © 2017 Fhict. All rights reserved.
//

import Foundation
import UIKit

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



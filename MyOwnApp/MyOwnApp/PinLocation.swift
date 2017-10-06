//
//  PinLocation.swift
//  MyOwnApp
//
//  Created by Fhict on 29/09/2017.
//  Copyright © 2017 Fhict. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PinLocation: NSObject, MKAnnotation {
    
    var identifier = "Pin location"
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    {
        self.title = title
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    
}

class PinLocationList: NSObject {
    
    var pins = [PinLocation]()
    
    override init(){
        pins += [PinLocation(title: "Title1", latitude: 51.441642, longitude: 5.469175)]
        pins += [PinLocation(title: "Title2", latitude: 51.441221, longitude: 5.478515)]
    }
}


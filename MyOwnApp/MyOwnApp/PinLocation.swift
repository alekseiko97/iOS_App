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
    
    var identifier: String
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, identifier: String)
    {
        self.title = title
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.identifier = identifier
        
        
        super.init()
    }
    
    func mapItem() -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
}

class PinLocationList: NSObject {
    
  
    
    
    var pins = [PinLocation]()
    
    override init(){
        pins += [PinLocation(title: "Title1", latitude: 51.441642, longitude: 5.469175, identifier: "pin1")]
        pins += [PinLocation(title: "Title2", latitude: 51.438631, longitude: 5.469116, identifier: "pin2")]
    }
}


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
    
    var identifier = "pin"
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    {
        self.title = title
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
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
        pins += [PinLocation(title: "Title1", latitude: 51.441642, longitude: 5.469175)]
        pins += [PinLocation(title: "Title2", latitude: 51.438631, longitude: 5.469116)]
    }
}


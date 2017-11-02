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


class GeoLocation: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String)
    {
        self.title = title
        self.coordinate = coordinate
        self.radius = radius
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




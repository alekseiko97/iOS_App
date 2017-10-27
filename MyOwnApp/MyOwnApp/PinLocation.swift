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
        pins += [PinLocation(title: "Philips Stadion", latitude: 51.441723, longitude: 5.469444, identifier: "1")]
        pins += [PinLocation(title: "Philips Museum", latitude: 51.439083, longitude: 5.475667, identifier: "2")]
        pins += [PinLocation(title: "TU/e", latitude: 51.448033, longitude: 5.490986, identifier: "3")]
        pins += [PinLocation(title: "Sint Catharinakerk", latitude: 51.437112, longitude: 5.478978, identifier: "4")]
        pins += [PinLocation(title: "DAF Museum", latitude: 51.437148, longitude: 5.490589, identifier: "5")]
        
        
        
    }
}


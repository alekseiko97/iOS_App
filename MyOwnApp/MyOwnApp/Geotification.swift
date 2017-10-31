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


struct GeoKey {
    static let title = "title"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let radius = "radius"
    static let identifier = "identifier"
}

class Geotification: NSObject, NSCoding, MKAnnotation {
    
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
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: GeoKey.title)
        aCoder.encode(coordinate.latitude, forKey: GeoKey.latitude)
        aCoder.encode(coordinate.longitude, forKey: GeoKey.longitude)
        aCoder.encode(radius, forKey: GeoKey.radius)
        aCoder.encode(identifier, forKey: GeoKey.identifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: GeoKey.title) as? String
        let latitude = aDecoder.decodeDouble(forKey: GeoKey.latitude)
        let longitude = aDecoder.decodeDouble(forKey: GeoKey.longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        radius = aDecoder.decodeDouble(forKey: GeoKey.radius)
        identifier = aDecoder.decodeObject(forKey: GeoKey.identifier) as! String
    }
    
    func mapItem() -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
}




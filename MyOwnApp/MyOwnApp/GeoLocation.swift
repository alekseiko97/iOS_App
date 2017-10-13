//
//  GeoLocation.swift
//  MyOwnApp
//
//  Created by Fhict on 13/10/2017.
//  Copyright © 2017 Fhict. All rights reserved.
//

import UIKit
import MapKit

struct Location {
    let title: String
    let latitude: Double
    let longitude: Double
}

class GeoLocation: NSObject {
    
    var locations = [Location]()
    
    override init() {
        
        locations += [Location(title: "Title1", latitude: 51.441642, longitude: 5.469175)]
        locations += [Location(title: "Title2", latitude: 51.438631, longitude: 5.469116)]
        
    }
    
    
    
}

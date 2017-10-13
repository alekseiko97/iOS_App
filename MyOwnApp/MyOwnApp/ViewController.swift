//
//  ViewController.swift
//  MyOwnApp
//
//  Created by Fhict on 22/09/2017.
//  Copyright © 2017 Fhict. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let pins = PinLocationList().pins

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        addRegion()
        mapView.addAnnotations(pins)
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //locationManager.stopUpdatingLocation()
        self.mapView.showsUserLocation = true
        if let location = locations.first
        {
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 5000, 5000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func addRegion()
    {
        for pin in pins{
            let region = CLCircularRegion(center: pin.coordinate, radius: 100, identifier: pin.identifier)
            region.notifyOnEntry = true
            region.notifyOnExit = true
            let circle = MKCircle(center: region.center, radius: region.radius)
            mapView.add(circle)
            locationManager.startMonitoring(for: region)
            
        }
    }
    
    
    func showAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        showAlert(title: "You entered the region", message: "Time to do the task")
        print("Entered")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        showAlert(title: "Your are out of the region", message: "You're not available to do this task")
        print("Exit")
    }
  
   
    
     func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else {return MKOverlayRenderer()}
        let circleRenderer = MKCircleRenderer(circle: circleOverlay)
        circleRenderer.fillColor = .red
        circleRenderer.strokeColor = .red
        circleRenderer.alpha = 0.5
        return circleRenderer
    }
}




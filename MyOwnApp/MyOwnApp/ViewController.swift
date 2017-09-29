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

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        region()
        loadDefaultLocation()
        
    }
    
    func loadDefaultLocation()
    {
        let eindhovenCity = CLLocationCoordinate2DMake(51.441184, 5.472946)
        let region = MKCoordinateRegionMakeWithDistance(eindhovenCity, 5000, 5000)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationManager.stopUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
  
    
    func region()
    {
        let location = CLLocationCoordinate2DMake(51.441463, 5.498352)
        let region = CLCircularRegion(center: location, radius: 100, identifier: "Home")
        mapView.removeOverlays(mapView.overlays)
        locationManager.startMonitoring(for: region)
        let circle = MKCircle(center: location, radius: region.radius)
        mapView.add(circle)
        
        /*
        region.notifyOnEntry = (geotification.eventType == .onEntry)
        region.notifyOnExit = (geotification.eventType == .onExit)
        */
    }
    
   /* func startMonitoring() {
        
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(withTitle:"Error", message: "Geofencing is not supported on this device!")
            return
        }
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showAlert(withTitle: "Warning", message: "Your geotification is saved but will only be activated once you grant permission to access the device location.")
        }
        
        let region = self.region()
        locationManager.startMonitoring(for: region)
    }
    
    func stopMonitoring() {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion,
                circularRegion.identifier == region.identifier else {continue}
            locationManager.stopMonitoring(for: circularRegion)
        }
    } */
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else {return MKOverlayRenderer()}
        let circleRenderer = MKCircleRenderer(circle: circleOverlay)
        circleRenderer.fillColor = .red
        circleRenderer.strokeColor = .red
        circleRenderer.alpha = 0.5
        return circleRenderer
    }

}


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
import FirebaseDatabase

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var geolocations: [GeoLocation] = []
    var tasks: [Task] = []
    var ref: DatabaseReference!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference().child("Tasks")
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        loadAllLocations()
        loadAllTasks()
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      self.navigationItem.title = "Received points: \(delegate.score)"
    }
    
    func loadAllLocations()
    {
        geolocations += [GeoLocation(title: "Philips Stadion", coordinate: CLLocationCoordinate2DMake(51.441723, 5.469444), radius: 100, identifier: "1")]
        geolocations += [GeoLocation(title: "Philips Museum", coordinate: CLLocationCoordinate2DMake(51.439083, 5.475667), radius: 100, identifier: "2")]
        geolocations += [GeoLocation(title: "TU/e", coordinate: CLLocationCoordinate2DMake(51.448033, 5.490986), radius: 100, identifier: "3")]
        geolocations += [GeoLocation(title: "Sint Catharinakerk", coordinate: CLLocationCoordinate2DMake(51.437112, 5.478978), radius: 100, identifier: "4")]
        geolocations += [GeoLocation(title: "DAF Museum", coordinate: CLLocationCoordinate2DMake(51.437148, 5.490589), radius: 100, identifier: "5")]
        
        for x in geolocations
        {
            add(geolocation: x)
        }
    }
    
    func loadAllTasks()
    {
        ref?.observe(.childAdded, with: { (snapshot) in
            
            if let x = snapshot.value as? [String:Any] {
                
                let taskName = x["taskName"] as? String
                let taskDescription = x["taskDescription"] as? String
                let identifier = x["identifier"] as? Int
                let correctAnswer = x["correctAnswer"] as? String
                let receivedPoints = x["receivedPoints"] as! Int
                self.tasks.append(Task(taskName: taskName!, taskDescription: taskDescription!, identifier: identifier!, correctAnswer: correctAnswer!, receivedPoints: receivedPoints))
                
            }
        })
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
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
    
    // MARK: Map overlay functions
    func addRadiusOverlay(forGeolocation geolocation: GeoLocation) {
        mapView?.add(MKCircle(center: geolocation.coordinate, radius: geolocation.radius))
    }
    
    func removeRadiusOverlay(forGeolocation geolocation: GeoLocation) {
        // Find exactly one overlay which has the same coordinates & radius to remove
        guard let overlays = mapView?.overlays else { return }
        for overlay in overlays {
            guard let circleOverlay = overlay as? MKCircle else { continue }
            let coord = circleOverlay.coordinate
            if coord.latitude == geolocation.coordinate.latitude && coord.longitude == geolocation.coordinate.longitude && circleOverlay.radius == geolocation.radius {
                mapView?.remove(circleOverlay)
                break
            }
        }
    }
    
    // MARK: Functions that update the model/associated views with geotification changes
    func add(geolocation: GeoLocation) {
        mapView.addAnnotation(geolocation)
        addRadiusOverlay(forGeolocation: geolocation)
        startMonitoring(geolocation: geolocation)
    }
    
    func remove(geolocation: GeoLocation) {
        if let indexInArray = geolocations.index(of: geolocation) {
            geolocations.remove(at: indexInArray)
        }
        mapView.removeAnnotation(geolocation)
        removeRadiusOverlay(forGeolocation: geolocation)
        stopMonitoring(geolocation: geolocation)
    }
    
    
    func region(withGeolocation geolocation: GeoLocation) -> CLCircularRegion {
        let region = CLCircularRegion(center: geolocation.coordinate, radius: geolocation.radius, identifier: geolocation.identifier)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }
    
    func showAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithTask(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let declineAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let acceptAction = UIAlertAction(title: "Accept", style: .default) {  (_) -> Void in
            self.performSegue(withIdentifier: "segue", sender: self)
        }
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        showAlertWithTask(title: "You entered the region", message: "Time to do the task")
        print("Entered")
        
        for x in geolocations
        {
            if x.identifier == region.identifier
            {
                for task in tasks
                {
                    if String(task.identifier) == x.identifier
                    {
                        self.delegate.taskName = task.taskName
                        self.delegate.taskDescription = task.taskDescription
                        self.delegate.correctAnswer = task.correctAnswer
                        self.delegate.receivedPoints = task.receivedPoints
                    }
                }
            }
        }
        
    }
    
      
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit")
        
        if delegate.isCompleted == true
        {
            for x in geolocations
            {
                if x.identifier == region.identifier
                {
                    for task in tasks
                    {
                        if String(task.identifier) == x.identifier
                        {
                            self.delegate.solvedTasks.append(task)
                        }
                    }
                    self.remove(geolocation: x)
                }
            }
        }
        else
        {
            showAlert(title: "Your are out of the region", message: "You're not available to do this task")
        }
    }
    
    
    
    
    func startMonitoring(geolocation: GeoLocation) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(title: "Error", message: "Monitoring is not supported on this device!")
            return
        }
        
        let region = self.region(withGeolocation: geolocation)
        locationManager.startMonitoring(for: region)
    }
    
    func stopMonitoring(geolocation: GeoLocation) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geolocation.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
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




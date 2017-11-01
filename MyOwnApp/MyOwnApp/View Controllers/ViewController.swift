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

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var geotifications: [Geotification] = []
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
        geotifications += [Geotification(title: "Philips Stadion", coordinate: CLLocationCoordinate2DMake(51.441723, 5.469444), radius: 100, identifier: "1")]
        geotifications += [Geotification(title: "Philips Museum", coordinate: CLLocationCoordinate2DMake(51.439083, 5.475667), radius: 100, identifier: "2")]
        geotifications += [Geotification(title: "TU/e", coordinate: CLLocationCoordinate2DMake(51.448033, 5.490986), radius: 100, identifier: "3")]
        geotifications += [Geotification(title: "Sint Catharinakerk", coordinate: CLLocationCoordinate2DMake(51.437112, 5.478978), radius: 100, identifier: "4")]
        geotifications += [Geotification(title: "DAF Museum", coordinate: CLLocationCoordinate2DMake(51.437148, 5.490589), radius: 100, identifier: "5")]
        
        for x in geotifications
        {
            add(geotification: x)
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
    func addRadiusOverlay(forGeotification geotification: Geotification) {
        mapView?.add(MKCircle(center: geotification.coordinate, radius: geotification.radius))
    }
    
    func removeRadiusOverlay(forGeotification geotification: Geotification) {
        // Find exactly one overlay which has the same coordinates & radius to remove
        guard let overlays = mapView?.overlays else { return }
        for overlay in overlays {
            guard let circleOverlay = overlay as? MKCircle else { continue }
            let coord = circleOverlay.coordinate
            if coord.latitude == geotification.coordinate.latitude && coord.longitude == geotification.coordinate.longitude && circleOverlay.radius == geotification.radius {
                mapView?.remove(circleOverlay)
                break
            }
        }
    }
    
    // MARK: Functions that update the model/associated views with geotification changes
    func add(geotification: Geotification) {
        mapView.addAnnotation(geotification)
        addRadiusOverlay(forGeotification: geotification)
        startMonitoring(geotification: geotification)
    }
    
    func remove(geotification: Geotification) {
        if let indexInArray = geotifications.index(of: geotification) {
            geotifications.remove(at: indexInArray)
        }
        mapView.removeAnnotation(geotification)
        removeRadiusOverlay(forGeotification: geotification)
        stopMonitoring(geotification: geotification)
    }
    
    
    func region(withGeotification geotification: Geotification) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
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
        
        for x in geotifications
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
            for x in geotifications
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
                        self.remove(geotification: x)
                }
            }
        }
        else
        {
            showAlert(title: "Your are out of the region", message: "You're not available to do this task")
        }
    }
    
    
    
    
    func startMonitoring(geotification: Geotification) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(title: "Error", message: "Monitoring is not supported on this device!")
            return
        }
        
        let region = self.region(withGeotification: geotification)
        locationManager.startMonitoring(for: region)
    }
    
    func stopMonitoring(geotification: Geotification) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
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




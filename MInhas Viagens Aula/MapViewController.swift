//
//  MapViewController.swift
//  MInhas Viagens Aula
//
//  Created by Christian Rezende on 20/07/22.
//  Copyright © 2022 Christian Rezende. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    var travel: Dictionary<String,String> = [:]
    
    var selectedIndex : Int! = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("SELECTED ITEM",selectedIndex)
        if let index = selectedIndex {
            if index == -1 {
                setupLocationManager()

            }else {
                addAnnotationMap(travel:self.travel)
            }
        }
      
        let handleTouch = UILongPressGestureRecognizer(target: self, action: #selector(checkMap))
        
        handleTouch.minimumPressDuration = 2
        map.addGestureRecognizer(handleTouch)
    }
    
   
    
    @objc func checkMap(gesture:UILongPressGestureRecognizer){
        
        if(gesture.state == UIGestureRecognizer.State.began){
            print("Check pressed")
            
            // Get the point selected
            let selectedPoint = gesture.location(in: self.map)
            let coordinates = map.convert(selectedPoint, toCoordinateFrom: self.map)
            let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            
            // recover address of point selected
            
            var localName = ""
            var localAddress = ""
            var localComplete = "Not found address"
            
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if error == nil {
                    if let localData = placemarks?.first {
                        if let name = localData.name {
                            localComplete = name
                        }else {
                            if let address = localData.thoroughfare {
                                localComplete = address
                            }
                        }
                    }
                    //Save Travel
                    self.travel = ["local":localComplete,"latitude":String(coordinates.latitude),"longitude":String(coordinates.longitude)]
                    StoreData().saveTravel(travel:self.travel)
                    
                    print(StoreData().listTrips())
                    
                    self.addAnnotationMap(travel:self.travel)
                    
                }else {
                    print("Get address ERROR")
                }
            }
            
    
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {
            let alertController = UIAlertController(title: "Location Permission", message: "Location permission is necessary to continue", preferredStyle: .alert)
            let actionConfigs = UIAlertAction(title: "Open Configs", style: .default) { (alertConfigs) in
                if let configs = NSURL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(configs as URL)
                }
            }
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alertController.addAction(actionConfigs)
            alertController.addAction(actionCancel)
            
            present(alertController,animated:true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!
        
        showLocal(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
    }

    fileprivate func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func showLocal(latitude:Double,longitude:Double) {
       
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span  = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
    }
    
    
    fileprivate func addAnnotationMap(travel:Dictionary<String,String>) {
        if let localTravel = travel["local"]{
            if let latitudeStr = travel["latitude"]{
                if let longitudeStr = travel["longitude"]{
                    if let latitude = Double(latitudeStr){
                        if let longitude = Double(longitudeStr){
                            
                            // Show notation
                            let annotation = MKPointAnnotation()
                            
                            annotation.coordinate.latitude = latitude
                            annotation.coordinate.longitude = longitude
                            annotation.title=localTravel
                            annotation.subtitle="I'm here"
                            
                            self.map.addAnnotation(annotation)
                            
                            
                            // Show Location on map
                            
                            self.showLocal(latitude:latitude,longitude:longitude)
                           
                        }
                    }
                }
            }
        }
        
    }
}

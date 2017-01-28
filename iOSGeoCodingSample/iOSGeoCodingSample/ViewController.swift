//
//  ViewController.swift
//  iOSGeoCodingSample
//
//  Created by Viraj Padte on 1/27/17.
//  Copyright © 2017 Bit2Labz. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate{

    @IBOutlet weak var map: MKMapView!
    //mode 1 for add and mode 2 to view
    //default mode is add
    var mode = 1
    var longPassed:CLLocationDegrees = 0.0
    var latPassed:CLLocationDegrees = 0.0
    var selectedName = ""
    let locMan = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("maps always")
        
        print("passsed values  \(latPassed) and \(longPassed)")
        
        
        //check if somedata is present in permanent memory
        if let dataStored = UserDefaults.standard.object(forKey: "pem_data") as? [String : [String : CLLocationDegrees]]{
            print(dataStored)
        }
        if mode == 1{
            print("add more")
            locMan.delegate = self
            locMan.desiredAccuracy =  kCLLocationAccuracyBest
            locMan.requestWhenInUseAuthorization()
            locMan.startUpdatingLocation()
            
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPressed(getGestureInformation:)))
            longPress.minimumPressDuration = 2
            map.addGestureRecognizer(longPress)
        }else if mode == 2{
            print("plot_mode")
            //plot the location
            let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latPassed, longitude: longPassed)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            map.setRegion(region, animated: true)
            
            //insert the annotation
            let annotation = MKPointAnnotation()
            annotation.title = selectedName
            annotation.coordinate =  coordinate
            map.addAnnotation(annotation)
        }
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[0].coordinate
        print(currentLocation)
        let region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        map.setRegion(region, animated: true)
        print("updated once")
        locMan.stopUpdatingLocation()
        
        
    }
    
    func longPressed(getGestureInformation: UIGestureRecognizer){
        var locationName = ""
        
        if getGestureInformation.state == UIGestureRecognizerState.began{
            let touchCoordinates = getGestureInformation.location(in: self.map)
            let mapCoordinates = map.convert(touchCoordinates, toCoordinateFrom: self.map)
            //add annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = mapCoordinates
            
            //get location title by reverse geocoding
            //include possibility where you dont end up finding a name of the location
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: mapCoordinates.latitude, longitude: mapCoordinates.longitude)
            
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placeMarks, error) in
                if error != nil{
                    print(error)
                }
                else{
                    print("check no error")
                    locationName = (placeMarks?[0].name)! as String
                    print(locationName)
                }
                annotation.title = locationName
                self.map.addAnnotation(annotation)
                
                //check if places data exists
                
                if let dataStored = UserDefaults.standard.object(forKey: "pem_data") as? [String : [String : CLLocationDegrees]]{
                    //then permanent data exists
                    var tempHandler = dataStored
                    var locationData = [String : CLLocationDegrees]()
                    locationData["lattitude"] = location.coordinate.latitude
                    locationData["longitude"] = location.coordinate.longitude
                    tempHandler[locationName] = locationData
                    //add to the existing pem data
                    UserDefaults.standard.set(tempHandler, forKey: "pem_data")
                }
                else{
                    //create a tempPlacesDictionary
                    var tempPlacesDict = [String : [String : CLLocationDegrees]]()
                    //create location data
                    var locationData = [String : CLLocationDegrees]()
                    locationData["lattitude"] = location.coordinate.latitude
                    locationData["longitude"] = location.coordinate.longitude
                    tempPlacesDict[locationName] = locationData
                    //add to the existing pem data
                    UserDefaults.standard.set(tempPlacesDict, forKey: "pem_data")
                }
               
                
        
            })
            
            
            
        }
        
    }


}


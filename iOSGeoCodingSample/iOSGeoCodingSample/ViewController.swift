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
    
    let locMan = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locMan.delegate = self
        locMan.desiredAccuracy =  kCLLocationAccuracyBest
        locMan.requestWhenInUseAuthorization()
        locMan.startUpdatingLocation()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPressed(getGestureInformation:)))
        longPress.minimumPressDuration = 2
        map.addGestureRecognizer(longPress)
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
        
        //add annotation just to check if this works
        //let annotation = MKPointAnnotation()
        //annotation.coordinate = currentLocation
        //map.addAnnotation(annotation)
    }
    
    func longPressed(getGestureInformation: UIGestureRecognizer){
        if getGestureInformation.state == UIGestureRecognizerState.began{
            print("detected")
        }
        
    }


}


//
//  TableViewController.swift
//  iOSGeoCodingSample
//
//  Created by Viraj Padte on 1/28/17.
//  Copyright © 2017 Bit2Labz. All rights reserved.
//

import UIKit
import MapKit

class TableViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    var tempPlacesDict = [String : [String : CLLocationDegrees]]()
    var selectedLat:CLLocationDegrees = 0.0
    var selectedLong:CLLocationDegrees = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        //check if somedata is present in the permanent memory
        if let dataStored = UserDefaults.standard.object(forKey: "pem_data") as? [String : [String : CLLocationDegrees]]{
            //print(dataStored)
            //update the class variable
            tempPlacesDict = dataStored
            print(tempPlacesDict.count)
        }else{
            print("No data present")
        }
        table.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows//
        return tempPlacesDict.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        print(tempPlacesDict)
        cell.textLabel?.text = Array(tempPlacesDict.keys)[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("after")
        let selectedLocation = Array(tempPlacesDict.keys)[indexPath.row]
        if let selectedData = tempPlacesDict[selectedLocation]! as? [String : CLLocationDegrees]{
            selectedLat = selectedData["lattitude"]!
            selectedLong = selectedData["longitude"]!
            print("passed")
            print(selectedLong)
        }
        performSegue(withIdentifier: "toMap", sender: nil)
        
    }

        

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("before")
        if segue.identifier == "toMap"{
            let otherViewController = segue.destination as! ViewController
            otherViewController.mode = 2
            print(selectedLong)
            otherViewController.latPassed = selectedLat
            otherViewController.longPassed = selectedLong
        }
    }
}

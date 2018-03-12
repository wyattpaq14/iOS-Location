//
//  ViewController.swift
//  Location
//
//  Created by Wyatt Paquin on 3/11/18.
//  Copyright © 2018 Wyatt Paquin. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblZipCode: UILabel!
    @IBOutlet weak var lblLat: UILabel!
    @IBOutlet weak var lblLon: UILabel!
    
    
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        let latestLocation: CLLocation = locations[locations.count - 1]
        
        
        if startLocation == nil {
            startLocation = latestLocation
        }
        
        
        let geonamesURL = URL(string: "http://api.geonames.org/findNearbyPostalCodesJSON?lat=\(String(format: "%.4f", latestLocation.coordinate.latitude))&lng=\(String(format: "%.4f", latestLocation.coordinate.longitude))&radius=10&username=wyattpaq14")
        let task1 = URLSession.shared.dataTask(with: geonamesURL!) {(data, response, error) in
            
            
            
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let jsonNodes = json["postalCodes"] as? [[String: Any]] {
                    for node in jsonNodes {
                        if let zipcode = node["placeName"] as? String {
                            self.lblCity.text = "City: \(zipcode)"
                        }
                        if let zipcode = node["postalCode"] as? String {
                            self.lblZipCode.text = "Zip Code: \(zipcode)"
                        }
                        if let zipcode = node["adminName1"] as? String {
                            self.lblState.text = "State: \(zipcode)"
                        }
                    }
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
            
        }
        
        task1.resume()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        
    }



}


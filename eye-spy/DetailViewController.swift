//
//  DetailViewController.swift
//  Junior Quest
//
//  Created by Nathan on 9/17/16.
//  Copyright © 2016 Nathan Jones. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class DetailViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var MapView: UIView!
    var locationArray = [AnyObject]()
    var locationManager = CLLocationManager()
    var mapview : GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // create and initialize an instance of GMSMapView. Create a GMSCameraPostion that tells the map to displya the coordinate of points
        
        
        if CLLocationManager.locationServicesEnabled(){
            
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
                
                let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 10.0)
                let rect = CGRect(x: 0, y: 0, width: self.MapView.frame.size.width, height: self.MapView.frame.size.height)
                mapview = GMSMapView.map(withFrame: rect, camera: camera)
                mapview.isMyLocationEnabled = true
                mapview.mapType = kGMSTypeNormal
                self.MapView.addSubview(mapview)
                
                //get location array from nsuserdefault
                var i = 0
                for Dictionary in locationArray as! [[String : String]]{
                    let marker  = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: Double(Dictionary["latitude"]!)!, longitude: Double(Dictionary["longitude"]!)!)
                    marker.title = Dictionary["image"]!
                    marker.map = mapview
                    i += 1
                }

            }
            
        }
        
    }


    @IBAction func back(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

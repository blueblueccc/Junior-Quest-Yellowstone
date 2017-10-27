//
//  MapViewController.swift
//  Junior Quest
//
//  Created by Nathan on 9/10/16.
//  Copyright © 2016 Nathan Jones. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var MapView: UIView!
    var locationManager = CLLocationManager()
    var mapview : GMSMapView!
    var locatinArray = [AnyObject]()
    var popUp : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // create and initialize an instance of GMSMapView. Create a GMSCameraPostion that tells the map to displya the coordinate of points
        if CLLocationManager.locationServicesEnabled(){
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                let alert = UIAlertController.init(title: "Warning", message: "You can't access Location Acess", preferredStyle:UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
            case .authorizedAlways, .authorizedWhenInUse:
                let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 10.0)
                let rect = CGRect(x: 0, y: 0, width: self.MapView.frame.size.width, height: self.MapView.frame.size.height)
                mapview = GMSMapView.map(withFrame: rect, camera: camera)
                mapview.isMyLocationEnabled = true
                mapview.mapType = kGMSTypeNormal
                self.MapView.addSubview(mapview)
            
                //get location array from nsuserdefault
                var i = 0
                if UserDefaults.standard.object(forKey: "locationArray") != nil{
                    for Dictionary in UserDefaults.standard.object(forKey: "locationArray") as! [[String : String]]{
                    
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: Double(Dictionary["latitude"]!)!, longitude: Double(Dictionary["longitude"]!)!)
                        marker.title = Dictionary["image"]!
                        marker.map = mapview
                        i += 1
                    }
                    print(UserDefaults.standard.object(forKey: "locationArray") as! [[String : String]])
                
                }
            }
            
        }
        
    }
    
    
    @IBAction func reset(_ sender: AnyObject) {
        
        // save points
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM dd, yyyy"
        let now = dateformatter.string(from: Date())
        
        var totalPoints = 0
        if UserDefaults.standard.integer(forKey: "totalPointsOfPages") > 0 {
            totalPoints = UserDefaults.standard.integer(forKey: "totalPointsOfPages")
        }
        
        var locationArray = [[String:String]]()
        
        if UserDefaults.standard.object(forKey: "locationArray") != nil {
            
            locationArray = UserDefaults.standard.object(forKey: "locationArray") as! [[String:String]]
        }
        
        let pointsOfDateDic:[String:AnyObject] = ["date" : now as AnyObject, "points" : String(format: "%d", totalPoints * 5) as AnyObject, "locations" : locationArray as AnyObject]
        var arrayWithPointsOfDate = [[String:AnyObject]]()
        
        if UserDefaults.standard.object(forKey: "arrayWithPointsOfDate") != nil {
            
            arrayWithPointsOfDate = UserDefaults.standard.object(forKey: "arrayWithPointsOfDate") as! [[String : AnyObject]]
            
        }
        
        arrayWithPointsOfDate.append(pointsOfDateDic)
        UserDefaults.standard.set(arrayWithPointsOfDate, forKey: "arrayWithPointsOfDate")
        
        UserDefaults.standard.removeObject(forKey: "locationArray")
        UserDefaults.standard.set(0, forKey: "totalPointsOfPage2")
        UserDefaults.standard.set(0, forKey: "totalPointsOfPage3")
        UserDefaults.standard.set(0, forKey: "totalPointsOfPages")
        UserDefaults.standard.set(0, forKey: "totalPoints")
        
        for i in 0...30 {
           
            UserDefaults.standard.set(false, forKey: String(format: "switch%d",i))
        }
        
        self.viewWillAppear(true)
    }

    @IBAction func gameHistory(_ sender: AnyObject) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "tableVC") as! HistoryViewController
        let nc = UINavigationController.init(rootViewController: viewController)
        nc.navigationBar.isHidden = true
        self.present(nc, animated: true, completion: nil)


    }
    
    @IBAction func showAbout(_ sender: AnyObject) {
        

        popUp = UIView.init(frame: CGRect(x: self.view.frame.size.width * 0.05, y: self.view.frame.size.height * 0.1, width: self.view.frame.size.width * 0.9, height: self.view.frame.size.height * 0.8))
        popUp.backgroundColor = UIColor.black
        popUp.layer.opacity = 0.8
        let title = UILabel.init(frame: CGRect(x: popUp.frame.size.width * 0.1, y: 20, width: popUp.frame.size.width * 0.8, height: 30))
        title.textColor = UIColor.white
        title.font = UIFont.boldSystemFont(ofSize: 22)
        title.textAlignment = NSTextAlignment.center
        title.text = "About Junior Quest"
        
        // custom Textview you can edit.
        let content = UITextView.init(frame: CGRect(x: popUp.frame.size.width * 0.1, y: 60, width: popUp.frame.size.width * 0.8, height: popUp.frame.size.height * 0.6))
        content.backgroundColor = UIColor.black
        content.layer.opacity = 0.8
        content.textColor = UIColor.white
        content.font = UIFont.boldSystemFont(ofSize: 14)
        content.textAlignment = NSTextAlignment.center
        //Please edit custome text below.
        content.text = "Copyright © 2016 Nathan Jones. All rights reserved."
        content.isEditable = false
        
        //colse button
        let close = UIButton.init(frame: CGRect(x: popUp.frame.size.width * 0.9, y: 10, width: 30, height: 30))
        close.setTitle("X", for: UIControlState())
        close.addTarget(self, action: #selector(dismissPopUp), for: .touchUpInside)
        
        popUp.addSubview(title)
        popUp.addSubview(content)
        popUp.addSubview(close)
        
        self.view.addSubview(popUp)
        
    }
    
    func dismissPopUp() {
        popUp.removeFromSuperview()
    }

}

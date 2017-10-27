//
//  ThirdViewController.swift
//  Junior Quest
//
//  Created by Nathan on 9/11/16.
//  Copyright © 2016 Nathan Jones. All rights reserved.
//

import UIKit
import CoreLocation

class ThirdViewController: UIViewController,CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var numberofImage: UILabel!
    @IBOutlet weak var totalPoints: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var imageArray: [UIImage] = []
    var imageNames: [String] = ["Continental Divide","Grand Canyon","Yellowstone Falls","Yellowstone Sign","Old Faithful Inn","Yellowstone Bus","Park Ranger","Yellowstone Lake","Anemone","Yellowstone River"]
    var totalPoint = 0
    var numberOfFoundedImages = 0
    var locationManager = CLLocationManager()
    var infoView = UIView()
    
    @IBAction func clickedSwitch(_ sender:UISwitch){
        
        let cell = sender.superview?.superview as! ImageCollectionViewCell
        if cell.pointSwitch.isOn{
            cell.points.text = "5"
            // save and retrieve number of images founded
            if UserDefaults.standard.integer(forKey: "totalPointsOfPage3") > 0 {
                totalPoint = UserDefaults.standard.integer(forKey: "totalPointsOfPage3")
            }
            totalPoint += 1
            
            if UserDefaults.standard.integer(forKey: "totalPointsOfPages") > 0 {
                numberOfFoundedImages = UserDefaults.standard.integer(forKey: "totalPointsOfPages")
            }
            numberOfFoundedImages += 1
            self.totalPoints.text = String(format: "%d Points", numberOfFoundedImages * 5)
            self.numberofImage.text = String(format: "%d/10 Page %d/30 Total",totalPoint, numberOfFoundedImages)
            //re save number of points
            UserDefaults.standard.set(totalPoint, forKey: "totalPointsOfPage3")
            UserDefaults.standard.set(numberOfFoundedImages, forKey: "totalPointsOfPages")
            
            // save founded image
            let indexPath = self.collectionView!.indexPath(for: cell)
            print((indexPath! as NSIndexPath).row)
            UserDefaults.standard.set(true, forKey: String(format: "switch%d",(indexPath! as NSIndexPath).row + 20))
            var imageStringArray = [String]()
            if UserDefaults.standard.object(forKey: "imageStrngArray") != nil {
                
                imageStringArray = UserDefaults.standard.object(forKey: "imageStrngArray") as! [String]
            }
            
            imageStringArray.append(cell.imageName.text!)
            print(imageStringArray)
            UserDefaults.standard.set(imageStringArray, forKey: "imageStrngArray")
            
            //get location
            self .getLocation(cell.imageName.text!)
            
        }else{
            cell.points.text = "0"
            let indexPath = self.collectionView!.indexPath(for: cell)
            // remove location of point when swipped off
            var locationArray = [[String:String]]()
            if UserDefaults.standard.object(forKey: "locationArray") != nil {
                
                locationArray = UserDefaults.standard.object(forKey: "locationArray") as! [[String : String]]
            }
            var i = 0
            for Dictionary in UserDefaults.standard.object(forKey: "locationArray") as! [[String : String]]{
                
                if cell.imageName.text == Dictionary["image"]!{
                    locationArray.remove(at: i)
                }
                i += 1
            }
            
            UserDefaults.standard.set(locationArray, forKey: "locationArray")
            
            UserDefaults.standard.set(false, forKey: String(format: "switch%d",(indexPath! as NSIndexPath).row + 20))
            
            if UserDefaults.standard.integer(forKey: "totalPointsOfPage3") > 0 {
                totalPoint = UserDefaults.standard.integer(forKey: "totalPointsOfPage3")
            }
            totalPoint -= 1
            
            if UserDefaults.standard.integer(forKey: "totalPointsOfPages") > 0 {
                numberOfFoundedImages = UserDefaults.standard.integer(forKey: "totalPointsOfPages")
            }
            numberOfFoundedImages -= 1
            self.totalPoints.text = String(format: "%d Points", numberOfFoundedImages * 5)
            self.numberofImage.text = String(format: "%d/10 Page %d/30 Total",totalPoint, numberOfFoundedImages)
            //re save number of points
            UserDefaults.standard.set(totalPoint, forKey: "totalPointsOfPage3")
            UserDefaults.standard.set(numberOfFoundedImages, forKey: "totalPointsOfPages")
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // declare collection view
        
        let cellWidth = self.collectionView.frame.size.width
        let cellHeight = self.collectionView.frame.size.height * 0.23
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        flowLayout.minimumLineSpacing = 10
        self.collectionView.setCollectionViewLayout(flowLayout, animated: false)
        
        for i in 21...30 {
            
            let image = UIImage(named: String(format: "image%d.jpeg",i))!
            imageArray.append(image)
            
        }

    }
    
    func onOrientationChange() {
        
        self.collectionView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(onOrientationChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        // get user current location
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if UserDefaults.standard.integer(forKey: "totalPointsOfPage3") > 0 {
            totalPoint = UserDefaults.standard.integer(forKey: "totalPointsOfPage3")
        }else{
            totalPoint = 0
        }
        
        if UserDefaults.standard.integer(forKey: "totalPointsOfPages") > 0 {
            numberOfFoundedImages = UserDefaults.standard.integer(forKey: "totalPointsOfPages")
        }else{
            numberOfFoundedImages = 0
        }
        self.totalPoints.text = String(format: "%d Points", numberOfFoundedImages * 5)
        self.numberofImage.text = String(format: "%d/10 Page %d/30 Total",totalPoint, numberOfFoundedImages)
        self.collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        cell.image.image = imageArray[(indexPath as NSIndexPath).row]
        
        // get full screen image
        cell.image.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(MainViewController.imageTapped(_:)))
        cell.image.addGestureRecognizer(gesture)
        cell.pointSwitch.isOn = UserDefaults.standard.bool(forKey: String(format: "switch%d", (indexPath as NSIndexPath).row + 20))
        if cell.pointSwitch.isOn != true{
            cell.points.text = "0"
        }else{
            cell.points.text = "5"
        }
        
        cell.imageName.text = self.imageNames[(indexPath as NSIndexPath).row]
        cell.infoButton.tag = (indexPath as NSIndexPath).row + 21
        cell.infoButton.addTarget(self, action: #selector(MainViewController.infoButtonPress(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
                return CGSize(width: UIScreen.main.bounds.size.width/2.0 - 16.0, height: 153.0)
            }
        }
        
        return CGSize(width: UIScreen.main.bounds.size.width - 16.0, height: 153.0)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager = manager
    }
    
    func getLocation(_ imageName : String) {
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                let alert = UIAlertController.init(title: "Warning", message: "You can't access Location Service", preferredStyle:UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                let location = locationManager.location?.coordinate
                
                let locationDictionary:[String:String] = ["image" : imageName, "latitude" : String (format: "%f",(location?.latitude)!), "longitude" : String (format: "%f",(location?.longitude)!)]
                var locationArray = [[String:String]]()
                
                if UserDefaults.standard.object(forKey: "locationArray") != nil {
                    
                    locationArray = UserDefaults.standard.object(forKey: "locationArray") as! [[String : String]]
                }
                
                locationArray.append(locationDictionary)
                UserDefaults.standard.set(locationArray, forKey: "locationArray")
            }
            
        }
    }
    
    func imageTapped(_ sender : UITapGestureRecognizer){
        
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = UIColor.black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    func infoButtonPress(_ sender:UIButton){
        
        infoView = UIView.init(frame: CGRect(x: self.view.frame.size.width * 0.05, y: self.view.frame.size.height * 0.1, width: self.view.frame.width * 0.9, height: self.view.frame.size.height * 0.8))
        infoView.backgroundColor = UIColor.black
        infoView.layer.opacity = 0.8
        let title = UILabel.init(frame: CGRect(x: infoView.frame.size.width * 0.1, y: 20, width: infoView.frame.size.width * 0.8, height: 20))
        title.textColor = UIColor.white
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = NSTextAlignment.center
        title.text = String(format: imageNames[sender.tag - 21])
        
        let content = UITextView.init(frame: CGRect(x: infoView.frame.size.width * 0.1, y: 60, width: infoView.frame.size.width * 0.8, height: infoView.frame.size.height*0.6))
        content.isEditable = false
        content.backgroundColor = UIColor.black
        content.layer.opacity = 0.8
        content.textColor = UIColor.white
        content.font = UIFont.boldSystemFont(ofSize: 14)
        content.textAlignment = NSTextAlignment.center
        
        content.text = self.readInfoTextFromFile(sender.tag) as String
        let closeButton = UIButton.init(frame: CGRect(x: infoView.frame.size.width * 0.9, y: 10, width: 30,height: 30))
        closeButton.setTitle("X", for: UIControlState())
        closeButton.addTarget(self, action: #selector(closeButtonPress), for: .touchUpInside)
        
        infoView.addSubview(title)
        infoView.addSubview(content)
        infoView.addSubview(closeButton)
        
        self.view.addSubview(infoView)
    }
    
    func closeButtonPress(){
        infoView.removeFromSuperview()
    }
    
    
    func readInfoTextFromFile(_ index:NSInteger) -> NSString {
        
        let filePath = Bundle.main.path(forResource: "InfoTexts", ofType: "json")
        var jsonData:Data? = nil
        do {
            jsonData = try Data(contentsOf: URL(fileURLWithPath: filePath!), options: NSData.ReadingOptions.mappedIfSafe)
        }
        catch {
            print("Handle \(error) here")
        }
        
        var json:[String:String] = [:]
        do {
            json = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! Dictionary
        } catch {
            print(error)
        }
        let string = json[String(format : "info_%d",index)]!
        return string as NSString
    }



}

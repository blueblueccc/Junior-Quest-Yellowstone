//
//  SightsViewController.swift
//  Eye-Spy
//
//  Created by son on 11/15/16.
//  Copyright © 2016 Adrian. All rights reserved.
//

import UIKit
import CoreLocation

class SightsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var numberofImage: UILabel!
    @IBOutlet weak var totalPoints: UILabel!
    @IBOutlet weak var btnCheck: DOFavoriteButton!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var imgUncheck: UIImageView!
    
    // MARK: - Properties
    var imageArray: [UIImage] = []
    var imageNames: [String] = ["Continental Divide","Grand Canyon","Yellowstone Falls","Yellowstone Sign","Old Faithful Inn","Yellowstone Bus","Park Ranger","Yellowstone Lake","Anemone","Yellowstone River"]
    var totalPoint = 0
    var numberOfFoundedImages = 0
    var pointsOfDate = 0
    var locationManager = CLLocationManager()
    var infoView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 21...30 {
            
            let image = UIImage(named: String(format: "image%d.jpeg",i))!
            imageArray.append(image)
            
        }
        
        imageName.text = imageNames[0]
        
        btnCheck.isSelected = UserDefaults.standard.bool(forKey: "switch" + String(20))
        if btnCheck.isSelected != true {
            
            points.text = "0"
            btnCheck.isHidden = true
            imgUncheck.isHidden = false
            
        }
        else {
            
            points.text = "5"
            btnCheck.isHidden = false
            imgUncheck.isHidden = true
            
        }
        
        carousel.delegate = self
        carousel.type = .coverFlow
        carousel.scrollSpeed = 1
        carousel.decelerationRate = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapImageUncheck))
        imgUncheck.isUserInteractionEnabled = true
        imgUncheck.addGestureRecognizer(tapGesture)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(onOrientationChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if UserDefaults.standard.integer(forKey: "totalPoints") > 0 {
            totalPoint = UserDefaults.standard.integer(forKey: "totalPoints")
        }else{
            totalPoint = 0
        }
        if UserDefaults.standard.integer(forKey: "totalPointsOfPages") > 0 {
            numberOfFoundedImages = UserDefaults.standard.integer(forKey: "totalPointsOfPages")
        }else{
            numberOfFoundedImages = 0
        }
        self.numberofImage.text = String(format: "%d/10 Page %d/30 Total",totalPoint, numberOfFoundedImages)
        self.totalPoints.text = String(format: "%d Points", numberOfFoundedImages * 5)
        
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    func onOrientationChange() {
        
        
        
    }
    
    // MARK: - IBActions
    
    @IBAction func onBtnInfo(_ sender: Any) {
        
        infoView = UIView.init(frame: CGRect(x: self.view.frame.size.width * 0.05, y: self.view.frame.size.height * 0.1, width: self.view.frame.width * 0.9, height: self.view.frame.size.height * 0.8))
        infoView.backgroundColor = UIColor.black
        infoView.layer.opacity = 0.8
        let title = UILabel.init(frame: CGRect(x: infoView.frame.size.width * 0.1, y: 20, width: infoView.frame.size.width * 0.8, height: 20))
        title.textColor = UIColor.white
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = NSTextAlignment.center
        title.text = String(format: imageNames[carousel.currentItemIndex])
        
        let content = UITextView.init(frame: CGRect(x: infoView.frame.size.width * 0.1, y: 60, width: infoView.frame.size.width * 0.8, height: infoView.frame.size.height*0.6))
        content.isEditable = false
        content.backgroundColor = UIColor.black
        content.layer.opacity = 0.8
        content.textColor = UIColor.white
        content.font = UIFont.boldSystemFont(ofSize: 14)
        content.textAlignment = NSTextAlignment.center
        
        content.text = readInfoTextFromFile(carousel.currentItemIndex + 20) as String
        let closeButton = UIButton.init(frame: CGRect(x: infoView.frame.size.width * 0.9, y: 10, width: 30,height: 30))
        closeButton.setTitle("X", for: UIControlState())
        closeButton.addTarget(self, action: #selector(closeButtonPress), for: .touchUpInside)
        
        infoView.addSubview(title)
        infoView.addSubview(content)
        infoView.addSubview(closeButton)
        
        self.view.addSubview(infoView)
        
    }
    
    @IBAction func onBtnCheck(_ sender: Any) {
        
        tapImageUncheck()
        
    }
    
    func tapImageUncheck() {
        
        if btnCheck.isSelected == false {
            
            btnCheck.isHidden = false
            imgUncheck.isHidden = true
            btnCheck.select()
            
            points.text = "5"
            
            // save and retrieve number of images founded
            if UserDefaults.standard.integer(forKey: "totalPoints") > 0 {
                totalPoint = UserDefaults.standard.integer(forKey: "totalPoints")
            }
            totalPoint += 1
            
            if UserDefaults.standard.integer(forKey: "totalPointsOfPages") > 0 {
                numberOfFoundedImages = UserDefaults.standard.integer(forKey: "totalPointsOfPages")
            }
            numberOfFoundedImages += 1
            self.totalPoints.text = String(format: "%d Points", numberOfFoundedImages * 5)
            self.numberofImage.text = String(format: "%d/10 Page %d/30 Total",totalPoint, numberOfFoundedImages)
            //re save number of points
            UserDefaults.standard.set(totalPoint, forKey: "totalPoints")
            UserDefaults.standard.set(numberOfFoundedImages, forKey: "totalPointsOfPages")
            
            // save founded image
            UserDefaults.standard.set(true, forKey: String(format: "switch%d",carousel.currentItemIndex + 20))
            
            var imageStringArray = [String]()
            if UserDefaults.standard.object(forKey: "imageStrngArray") != nil {
                
                imageStringArray = UserDefaults.standard.object(forKey: "imageStrngArray") as! [String]
            }
            
            imageStringArray.append(imageName.text!)
            UserDefaults.standard.set(imageStringArray, forKey: "imageStrngArray")
            
            self.getLocation(imageName.text!)
            
        }
        else {
            
            btnCheck.isHidden = true
            imgUncheck.isHidden = false
            btnCheck.deselect()
            
            points.text = "0"
            
            // remove location of point when swipped off
            var locationArray = [[String:String]]()
            if UserDefaults.standard.object(forKey: "locationArray") != nil {
                
                locationArray = UserDefaults.standard.object(forKey: "locationArray") as! [[String : String]]
            }
            var i = 0
            for Dictionary in UserDefaults.standard.object(forKey: "locationArray") as! [[String : String]]{
                
                if imageName.text == Dictionary["image"]!{
                    locationArray.remove(at: i)
                }
                i += 1
            }
            
            UserDefaults.standard.set(locationArray, forKey: "locationArray")
            
            UserDefaults.standard.set(false, forKey: String(format: "switch%d",carousel.currentItemIndex + 20))
            
            if UserDefaults.standard.integer(forKey: "totalPoints") > 0 {
                totalPoint = UserDefaults.standard.integer(forKey: "totalPoints")
            }
            totalPoint -= 1
            
            if UserDefaults.standard.integer(forKey: "totalPointsOfPages") > 0 {
                numberOfFoundedImages = UserDefaults.standard.integer(forKey: "totalPointsOfPages")
            }
            numberOfFoundedImages -= 1
            self.totalPoints.text = String(format: "%d Points", numberOfFoundedImages * 5)
            self.numberofImage.text = String(format: "%d/10 Page %d/30 Total",totalPoint, numberOfFoundedImages)
            //re save number of points
            UserDefaults.standard.set(totalPoint, forKey: "totalPoints")
            UserDefaults.standard.set(numberOfFoundedImages, forKey: "totalPointsOfPages")
            
        }
        
    }
    
    func imageTapped(_ index: Int) {
        
        let newImageView = UIImageView(image: imageArray[index])
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = UIColor.black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    func getLocation(_ imageName : String) {
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                
                let alert = UIAlertController.init(title: "Warning", message: "Location Services needs to be enabled to use the App.", preferredStyle:UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){
                    UIAlertAction in
                    UIApplication.shared.open(URL(fileURLWithPath : "prefs:root=Privacy"), options: [:], completionHandler: nil)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel){
                    UIAlertAction in
                }
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
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
                print(locationArray)
                
            }
            
        }
        else {
            
            let alert = UIAlertController.init(title: "Warning", message: "Location Services needs to be enabled to use the App.", preferredStyle:UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){
                UIAlertAction in
                UIApplication.shared.open(URL(fileURLWithPath : "prefs:root=Settings"), options: [:], completionHandler: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel){
                UIAlertAction in
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
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
        let string = json[String(format : "info_%d",index + 1)]!
        
        return string as NSString
        
    }
    
    func closeButtonPress(){
        infoView.removeFromSuperview()
    }
    
}

extension SightsViewController: iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 10
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let imgView = UIImageView(frame: vw.frame)
        
        if view == nil {
            
            imgView.image = imageArray[index]
            imgView.isUserInteractionEnabled = true
            vw.addSubview(imgView)
            vw.contentMode = .center
            
        }
        
        return vw
        
    }
    
    func numberOfPlaceholders(in carousel: iCarousel) -> Int {
        return 10
    }
    
    func carousel(_ carousel: iCarousel, placeholderViewAt index: Int, reusing view: UIView?) -> UIView {
        
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let imgView = UIImageView(frame: vw.frame)
        
        if view == nil {
            
            imgView.image = imageArray[index]
            imgView.isUserInteractionEnabled = true
            vw.addSubview(imgView)
            vw.contentMode = .center
            
        }
        
        return vw
        
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        switch option {
        case .wrap:
            return 1
        case .spacing:
            return value * 1.02
        case .fadeMax:
            if carousel.type == .custom {
                return 0
            }
            return value
        case .count:
            return 10
        default:
            return value
        }
        
    }
    
    func carousel(_ carousel: iCarousel, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
        
        let trans = CATransform3DRotate(transform, CGFloat(M_PI / 16), 0, 1, 0)
        return CATransform3DTranslate(trans, 0, 0, offset * carousel.itemWidth)
        
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        imageTapped(index)
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        
        imageName.text = imageNames[carousel.currentItemIndex]
        
        btnCheck.isSelected = UserDefaults.standard.bool(forKey: "switch" + String(carousel.currentItemIndex + 20))
        if btnCheck.isSelected != true {
            
            points.text = "0"
            btnCheck.isHidden = true
            imgUncheck.isHidden = false
            
        }
        else {
            
            points.text = "5"
            btnCheck.isHidden = false
            imgUncheck.isHidden = true
            
        }
        
    }
    
}

extension SightsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager = manager
    }
    
}

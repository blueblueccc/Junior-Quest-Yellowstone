//
//  HistoryViewController.swift
//  Junior Quest
//
//  Created by Nathan on 9/14/16.
//  Copyright © 2016 Nathan Jones. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBAction func dismiss(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var tableView: UITableView!
    var dateArray = [String]()
    var pointsArray = [String]()
    var locationArray:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        if UserDefaults.standard.object(forKey: "arrayWithPointsOfDate") != nil {
            
            for Dictionary in UserDefaults.standard.object(forKey: "arrayWithPointsOfDate") as! [[String : AnyObject]]{
                dateArray.append(Dictionary["date"]! as! String)
                pointsArray.append(Dictionary["points"]! as! String)
                locationArray.add(Dictionary["locations"]!)
            }
            
        }

    }

    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if dateArray.count != 0{
            return dateArray.count
        }else{
            return 0
        }
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        
        if dateArray.count != 0{
            cell.date.text = dateArray[(indexPath as NSIndexPath).row]
            cell.points.text = pointsArray[(indexPath as NSIndexPath).row]
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let dec = self.locationArray[(indexPath as NSIndexPath).row]
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        viewController.locationArray = dec as! [AnyObject]
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}

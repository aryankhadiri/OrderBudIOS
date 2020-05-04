//
//  RestaurantMenuViewController.swift
//  OrderBud
//
//  Created by Aryan Khadiri on 5/3/20.
//  Copyright © 2020 AryanKhadiri@gmail.com. All rights reserved.
//

import UIKit
import Parse
class RestaurantMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    //name of the restaurant is the itemInfo String
    var restaurant:PFObject!
    var foods = [PFObject]()
    func takingQuery(){
        let query = PFQuery(className: "Foods")
        query.whereKey("restaurant", equalTo: restaurant)
        query.findObjectsInBackground { (foods, error) in
            if foods != nil{
                print("Menu loaded successfully")
                self.foods = foods!
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        takingQuery()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let food = foods[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell") as! FoodCellTableViewCell
        let imageFile = food["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string:urlString)!
        let data = try? Data(contentsOf: url)
        cell.foodImageView?.image = UIImage(data: data!)
        
        cell.foodNameLabel.text = food["name"] as? String
        
        
        return cell
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let food = foods[indexPath.row]
        
        let foodDetailsViewController = segue.destination as! foodDetailsViewController
        foodDetailsViewController.food = food
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}

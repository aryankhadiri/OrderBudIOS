//
//  ViewController.swift
//  OrderBud
//
//  Created by Aryan Khadiri on 4/16/20.
//  Copyright © 2020 AryanKhadiri@gmail.com. All rights reserved.
//

import UIKit
import Parse
class ViewController: UIViewController {
    
    
    var restaurants = [PFObject]()
    var foods = [PFObject]()
    //var restaurantsNames:[String] = []
    var infoDict:[String:[Any]]=[:]
    
    
       func takingQuery(){
           let query = PFQuery(className: "Restaurants")
           query.includeKeys(["Name","city","state"])
           query.findObjectsInBackground { (restaurants, error) in
               if restaurants != nil{
                   print("Restaurants Successfully Loaded")
                   self.restaurants = restaurants!
                for restaurant in self.restaurants {
                    let name = restaurant["Name"] as! String
                    let city = restaurant["city"] as! String
                    let state = restaurant["state"] as! String
                    self.infoDict[name] = [city,state,"restaurant", restaurant]
                }
                let query1 = PFQuery(className: "Foods")
                query1.includeKeys(["name","restaurant.Name","restaurant.city"])
                query1.findObjectsInBackground{(foods, error) in
                    if foods != nil{
                        print("Foods Loaded Successfully")
                        self.foods = foods!
                    }
                    for food in self.foods{
                        let name = food["name"] as! String
                        let restaurant = food["restaurant"] as! PFObject
                        let restName = restaurant["Name"] as! String
                        let restCity = restaurant["city"] as! String
                        self.infoDict[name] = [restName, restCity, "food", food]
                    }
                    
                    
                }
               }
           }
        
       }
    
   
    //This is fake Restaurant data 
    let RestaurantNameArr = [ "NoodleA", "NoodleB","NoodleC","Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegowina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad"]
    var searchedRestaurant = [String]()
    var searching = false

    @IBOutlet weak var tbView: UITableView!
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        takingQuery()
            // Do any additional setup after loading the view.
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedRestaurant.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! searchTableViewCell
        if searching {
            cell.nameLabel.text = searchedRestaurant[indexPath.row]
            //cell.nameLabel.text = restaurants[indexPath.row]["Name"] as! String
            
            cell.cityLabel.text = infoDict[searchedRestaurant[indexPath.row]]?[0] as! String
            cell.stateLabel.text = infoDict[searchedRestaurant[indexPath.row]]?[1] as! String
            //cell?.textLabel?.text = searchedRestaurant[indexPath.row]
        } else {
            //cell.nameLabel.text = RestaurantNameArr[indexPath.row]
            cell.cityLabel.text = "San Jose"
            cell.stateLabel.text = "CA"
            //cell?.textLabel?.text = RestaurantNameArr[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(searchedRestaurant)
        let itemName = searchedRestaurant[indexPath.row]
        if infoDict[itemName]![2] as! String == "food"{
            self.performSegue(withIdentifier: "showDetailsFoodSegue", sender: self)
        }
        else{
            self.performSegue(withIdentifier: "showDetailsRestaurantSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        //let cell = sender as! UITableViewCell
        //let indexPath = tbView.indexPath(for: cell)
        let viewController = sender as! UIViewController
        let cell = viewController.view.viewWithTag(1) as! UITableViewCell
        let indexPath = tbView.indexPathForSelectedRow
        let itemName = searchedRestaurant[indexPath!.row]
        
        
        if segue.identifier == "showDetailsFoodSegue" {
            let dest = segue.destination as! foodDetailsViewController
            let food = infoDict[itemName]![3]
            dest.food = food as! PFObject
        }
        else if segue.identifier == "showDetailsRestaurantSegue" {
            let dest = segue.destination as! RestaurantMenuViewController
            let restaurant = infoDict[itemName]![3]
            dest.restaurant = restaurant as! PFObject
           
        }
        // Pass the selected object to the new view controller.
    }
    
}
        
extension ViewController: UISearchBarDelegate {

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
            searchedRestaurant = infoDict.keys.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})

           //searchedRestaurant = RestaurantNameArr.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
            if searchText == ""{
                searching = false
                tbView.reloadData()
            }
            else{
            searching = true
            tbView.reloadData()
            }
            }
            
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searching = false
            searchBar.text = ""
            tbView.reloadData()
        }
    @IBAction func UnwindAction(unwindSegue: UIStoryboardSegue){}

        
}


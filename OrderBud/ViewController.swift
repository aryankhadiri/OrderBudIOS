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
   
    //This is fake Restaurant data 
    let RestaurantNameArr = [ "NoodleA", "NoodleB","NoodleC","Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegowina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad"]
    var searchedRestaurant = [String]()
    var searching = false

    @IBOutlet weak var tbView: UITableView!
    
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            cell.cityLabel.text = "San Jose"
            cell.stateLabel.text = "CA"
            //cell?.textLabel?.text = searchedRestaurant[indexPath.row]
        } else {
            cell.nameLabel.text = RestaurantNameArr[indexPath.row]
            cell.cityLabel.text = "San Jose"
            cell.stateLabel.text = "CA"
            //cell?.textLabel?.text = RestaurantNameArr[indexPath.row]
        }
        return cell
    }
}
        
extension ViewController: UISearchBarDelegate {
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           searchedRestaurant = RestaurantNameArr.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
            searching = true
            tbView.reloadData()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searching = false
            searchBar.text = ""
            tbView.reloadData()
        }
        

}


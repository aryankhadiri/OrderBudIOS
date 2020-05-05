//
//  foodDetailsViewController.swift
//  OrderBud
//
//  Created by Aryan Khadiri on 5/3/20.
//  Copyright © 2020 AryanKhadiri@gmail.com. All rights reserved.
//

import UIKit
import Parse
class foodDetailsViewController: UIViewController {
    
    @IBOutlet weak var FoodImage: UIImageView!
    
    @IBOutlet weak var FoodName: UILabel!
    
    @IBOutlet weak var Description: UILabel!
    
    @IBOutlet weak var spicy: UISlider!
    
    @IBOutlet weak var sweet: UISlider!
    
    @IBOutlet weak var salted: UISlider!
    
    @IBOutlet weak var juicy: UISlider!
    
    
    @IBOutlet weak var review: UITextField!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    var food: PFObject!
    var Review: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(food)
        // Do any additional setup after loading the view.
        FoodName.text = food["name"] as? String
        Description.text = food["description"] as? String
        //image
        let imageFile = food["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string:urlString)!
        let data = try? Data(contentsOf: url)
        FoodImage.image = UIImage(data: data!)}
    

    func setValue(_ value: Float){
        spicy.value = Float(food["spicy"] as! Int)
        sweet.value = Float(food["sweet"] as! Int)
        salted.value = Float(food["salter"] as! Int)
        juicy.value = Float(food["juicy"] as! Int)
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

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
    
    @IBOutlet weak var ratingSlider: UISlider!
    
    @IBOutlet weak var reviewField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var overalRating: UILabel!
    @IBOutlet weak var ratingValueLabel: UILabel!
    
    var food: PFObject!
    var Review: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = food["name"] as! String
        self.title = name
        // Do any additional setup after loading the view.
        FoodName.text = food["name"] as? String
        Description.text = food["description"] as? String
        //image
        let imageFile = food["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string:urlString)!
        let data = try? Data(contentsOf: url)
        FoodImage.layer.cornerRadius = 30
        submitButton.layer.cornerRadius = 8
        FoodImage.image = UIImage(data: data!)
        setValue()
        
    }
        
    @IBAction func onSubmit(_ sender: Any) {
        let reviewText = reviewField.text
        let review = PFObject(className: "Reviews")
        review["text"] = reviewText
        let floatMultipicant = ratingSlider.value as! Float / 0.5
        let floatValue = floatMultipicant*0.5
        review["Rating"] = floatValue
        review["food"] = food
        var total_ratings = food["total_ratings"] as! Int
        total_ratings += 1
        food["total_ratings"] = total_ratings
        var overalRating = food["overalRating"] as! Float
        let newRating = roundf((overalRating + floatValue) / Float(total_ratings))
        food["overalRating"] = newRating
        
        
        review.saveInBackground { (success, error) in
            if success{
                print("Review Saved")
            }
            else{
                print(error)
            }
        }
    }
    
    func setValue(){
        spicy.value = Float(food["Spicy"] as! Int)
        sweet.value = Float(food["Sweet"] as! Int)
        salted.value = Float(food["Salty"] as! Int)
        juicy.value = Float(food["Juicy"] as! Int)
        let value = food["overalRating"] as! Float
        overalRating.text = value.description
        
        
        
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = sender.value
        let floatMultipicant = currentValue as! Float / 0.5
        let floatValue = floatMultipicant*0.5
        ratingValueLabel.text = currentValue.description
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

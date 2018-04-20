//
//  HomeDetailViewController.swift
//  FreshFood
//
//  Created by Brett Phillips on 4/18/18.
//  Copyright © 2018 Brett Phillips. All rights reserved.
//

import UIKit
import Photos

/**
 * Class that will present a detailed view of the selected
 * food item.
 */
class HomeDetailViewController: UIViewController {
    //Instance variables
    var foodItem: FoodModel = FoodModel()
    
    //IBOutlet variables
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var storageSpace: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var expirationDate: UILabel!
    
    /**
     * Function that will set up the ViewController with
     * the necessary values.
     */
    func initialSetUp() {
        foodName.text = foodItem.getName()
        storageSpace.text = foodItem.getStorageSpace()
        quantity.text = String(foodItem.getQuantity())
        setFoodImage()
        
        //If the food item is unknown, then they just added it
        //which means there is no set expiration date to display
        if foodItem.getImage() == "unknown" {
            expirationDate.text = "No Expiration Date"
        } else {
            //Format the date and set the value to be displayed
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            let date = dateFormatter.string(from: foodItem.getExpirationDate())
            expirationDate.text = date
        }
    }
    
    /**
     * Function that will get and display a
     * food image.
     */
    func setFoodImage() {
        //Split the path of the image to get the local identifer (Identifier:97890-8097...)
        let imagePathSplit = foodItem.getImage().split(separator: ":")
        
        //If the path is to the local identifier, then fetch it
        if imagePathSplit[0] == "Identifier" {
            //Fetch the image
            let asset = PHAsset.fetchAssets(withLocalIdentifiers: [String(imagePathSplit[1])], options: .none).firstObject
            
            //Check to see if the image fetched is nil
            if asset != nil {
                //Create the image manager and options
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                var imageFound = UIImage()
                //Request the image and assign the result to a UIImage object
                manager.requestImage(for: asset!, targetSize: CGSize(width: 3024.0, height: 4032.0), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                    imageFound = result!
                })
                
                //Set the image
                foodImage.image = imageFound
            } else {
                //If the image was not found, then use a default image
                foodImage.image = UIImage(named: "FreshFoodSecondaryLogo.png")
            }
        } else {
            //If the path is not a local identifier, then it references our camera roll
            //and already has a correct path
            foodImage.image = UIImage(named: foodItem.getImage())
        }
    }
    
    /**
     * Overriden function that will run after the view
     * has been loaded to set additional properties on
     * the view controller
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //Display our logo in the navbar
        displayLogo()
        //Set up the view controller
        initialSetUp()
    }
    
    /**
     * Overriden function that will prepare the next view controller
     * before navigation.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Gets the next view controller and sets its values, so they can be saved at the end of the form
        let foodFormPartOneController = segue.destination as! FoodFormPartOneViewController
        foodFormPartOneController.foodItem = foodItem
        //Pass the segue identifier we will reference this later to update the object through realm
        foodFormPartOneController.segueIdentifier = "EditFoodItem"
    }

}

//
//  FoodFormPartOneViewController.swift
//  FreshFood
//
//  Created by Brett Phillips on 3/22/18.
//  Copyright © 2018 Brett Phillips. All rights reserved.
//

import UIKit

/**
 * Class that will control the First food form. This form
 * is responsible for adding and editing food items, specifically
 * the food name, storage space, and quantity.
 */
class FoodFormPartOneViewController: UIViewController, UITextFieldDelegate {
    //Instance variables
    var foodItem: FoodModel = FoodModel()
    var segueIdentifier: String = ""
    var scannedItem: String?
    
    //IBOutlet variables
    @IBOutlet weak var storageSpace: UISegmentedControl!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var stepperValue: UIStepper!
    
    /**
     * IBAction that will change the quantity label, on
     * value changed, to show the correct quantity.
     */
    @IBAction func changeQuantity(_ sender: UIStepper) {
        //Get the value of the UIStepper and assign it to the UILabel
        quantity.text = String(Int(sender.value)) + " Item(s)"
        //Check to see if the entry is valid
        validateEntry()
    }
    
    /**
     * Function that will check to see if the user has filled
     * out the form fully.
     */
    func validateEntry() {
        //If the name is filled in, then enable the button to continue
        if name.text! != "" {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    /**
     * Function that will set up the ViewController with
     * the necessary values.
     */
    func initialSetUp() {
        //Check to see if this is an edit segue identifier
        if segueIdentifier == "EditFoodItem" {
            //Check and set the selected storage space for the grocery item
            switch(foodItem.getStorageSpace()) {
            case "Freezer":
                storageSpace.selectedSegmentIndex = StorageSpace.FREEZER_STORAGE_SPACE.rawValue
                break;
            case "Fridge":
                storageSpace.selectedSegmentIndex = StorageSpace.FRIDGE_STORAGE_SPACE.rawValue
                break;
            case "Pantry":
                storageSpace.selectedSegmentIndex = StorageSpace.PANTRY_STORAGE_SPACE.rawValue
                break;
            default:
                break;
            }
            
            //Set the other values
            name.text = foodItem.getName()
            quantity.text = String(foodItem.getQuantity()) + " Item(s)"
            stepperValue.value = Double(foodItem.getQuantity())
        } else if segueIdentifier == "barcodeScanner" {
            name.text = scannedItem!
        }
        
        //Check to see if the entry is valid
        validateEntry()
    }
    
    /**
     * Function that will run when the user clicks "return"
     * on the keyboard
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        name.resignFirstResponder()
        //Check to see if the entry is valid
        validateEntry()
        
        return true
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
        //Setup the ViewController
        initialSetUp()
    }

    /**
     * Overriden function that will prepare the next view controller
     * before navigation.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Gets the next view controller and sets its values, so they can be saved at the end of the form
        let foodFormPartTwo = segue.destination as! FoodFormPartTwoViewController
        foodFormPartTwo.storageSpace = storageSpace.titleForSegment(at: storageSpace.selectedSegmentIndex)!
        foodFormPartTwo.name = name.text!
        foodFormPartTwo.quantity = Int(stepperValue.value)
        
        //Check to see if this is an edit segue identifier
        if segueIdentifier == "EditFoodItem" {
            //If so, then pass the food item as well and the segue identifier
            //we will reference this later to update the object through realm
            foodFormPartTwo.foodItem = foodItem
            foodFormPartTwo.segueIdentifier = "EditFoodItem"
        }
    }
 

}

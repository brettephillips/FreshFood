//
//  GroceryFormViewController.swift
//  FreshFood
//
//  Created by Brett Phillips on 3/22/18.
//  Copyright © 2018 Brett Phillips. All rights reserved.
//

import UIKit

/**
 * Class that will control the grocery form. This form
 * is responsible for adding and editing grocery items.
 */
class GroceryFormViewController: UIViewController, UITextFieldDelegate {
    //Instance variables
    var groceryItem: GroceryModel = GroceryModel()
    var groceryInstance: GroceryWrapper = GroceryWrapper.groceryInstance
    var segueIdentifier: String = ""
    
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
     * IBAction that will add/edit a grocery item
     * and navigate back to the root controller.
     */
    @IBAction func add(_ sender: UIBarButtonItem) {
        //Check to see if this is an edit segue identifier
        if segueIdentifier == "EditGroceryItem" {
            //If yes, then update the grocery item
            groceryInstance.update(groceryItem: groceryItem,storageSpace: storageSpace.titleForSegment(at: storageSpace.selectedSegmentIndex)!, name: name.text!, quantity: Int(stepperValue.value))
        } else {
            //Else, instantiate a new GroceryModel object
            let groceryItem = GroceryModel(storageSpace: storageSpace.titleForSegment(at: storageSpace.selectedSegmentIndex)!, name: name.text!, quantity: Int(stepperValue.value))
            //Add the grocery item to the array
            groceryInstance.add(groceryItem: groceryItem)
        }
        
        //Send the user back to the root ViewController
        self.navigationController?.popToRootViewController(animated: true)
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
        if segueIdentifier == "EditGroceryItem" {
            //Check and set the selected storage space for the grocery item
            switch(groceryItem.getStorageSpace()) {
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
            name.text = groceryItem.getName()
            quantity.text = String(groceryItem.getQuantity()) + " Item(s)"
            stepperValue.value = Double(groceryItem.getQuantity())
            
            //Check to see if the entry is valid
            validateEntry()
            //Change the button to "Update"
            self.navigationItem.rightBarButtonItem?.title = "Update"
        }
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
}

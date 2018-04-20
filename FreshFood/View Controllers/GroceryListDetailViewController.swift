//
//  GroceryListDetailViewController.swift
//  FreshFood
//
//  Created by Brett Phillips on 4/18/18.
//  Copyright © 2018 Brett Phillips. All rights reserved.
//

import UIKit

/**
 * Class that will present a detailed view of the selected
 * grocery item.
 */
class GroceryListDetailViewController: UIViewController {
    //Instance Variables
    var groceryItem: GroceryModel = GroceryModel()
    
    //IBOutlet variables
    @IBOutlet weak var groceryName: UILabel!
    @IBOutlet weak var storageSpace: UILabel!
    @IBOutlet weak var quantity: UILabel!
    
    /**
     * Function that will set up the ViewController with
     * the necessary values.
     */
    func initialSetUp() {
        groceryName.text = groceryItem.getName()
        storageSpace.text = groceryItem.getStorageSpace()
        quantity.text = String(groceryItem.getQuantity())
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
        let groceryFormViewController = segue.destination as! GroceryFormViewController
        groceryFormViewController.groceryItem = groceryItem
        //Pass the segue identifier we will reference this later to update the object through realm
        groceryFormViewController.segueIdentifier = "EditGroceryItem"
    }

}

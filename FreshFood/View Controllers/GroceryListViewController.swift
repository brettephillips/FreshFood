//
//  GroceryListViewController.swift
//  FreshFood
//
//  Created by Brett Phillips on 3/22/18.
//  Copyright © 2018 Brett Phillips. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI

/**
 * Class that will display the grocery list to the
 * user.
 */
class GroceryListViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
    //Instance variables
    var groceryInstance: GroceryWrapper = GroceryWrapper.groceryInstance
    var foodInstance: FoodWrapper = FoodWrapper.foodInstance
    var groceryList: Results<GroceryModel>!
    
    /**
     * IBAction that will allow the user to share the
     * grocery list through text message.
     */
    @IBAction func share(_ sender: UIBarButtonItem) {
        //Local variable
        var textString: String = ""
        
        //Check to see if the user can send text messages
        if MFMessageComposeViewController.canSendText() {
            //Create a message view controller object and set its delegate
            let composeMessage = MFMessageComposeViewController()
            composeMessage.messageComposeDelegate = self
            
            //Loop through the items in the grocery list and add them to the string
            for item in groceryList {
                textString += item.getName() + " - " + String(item.getQuantity()) + "\n"
            }
            
            //Compose the body of the message
            composeMessage.body = textString
            //Present the view controller to the user, so they can send the message
            self.present(composeMessage, animated: true, completion: nil)
        }
    }
    
    /**
     * Function that will dismiss the message view controller
     * once the user has sent or cancelled the message.
     */
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    /**
     * Function that will check to see if the grocery list
     * has items in it.
     */
    func validateList() {
        //Only enable the share button if we have items in the grocery list
        if groceryList.count > 0 {
            self.navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }
    
    /**
     * Overriden function to determine the number of sections
     * to display in the table.
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /**
     * Overriden function to determine the number of rows
     * to display in the table.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryList.count
    }

    /**
     * Overriden function to setup the cells that will
     * be displayed in the table.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Get the reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = groceryList[indexPath.row].getName()
        cell.detailTextLabel?.text = String(groceryList[indexPath.row].getQuantity()) + " Quantity"
        
        return cell
    }

    /**
     * Function that will setup the table view with the ability
     * to swipe and delete an item in the array or add the item
     * to a storage area in the food list.
     */
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        //Create an add to storage action
        let addToStorage = UITableViewRowAction(style: .normal, title: "Add To Storage") { action, index in
            //Creates a new food model object
            let foodItem = FoodModel(storageSpace: self.groceryList[editActionsForRowAt.row].getStorageSpace(), name: self.groceryList[editActionsForRowAt.row].getName(), quantity: self.groceryList[editActionsForRowAt.row].getQuantity(), image: "unknown", expirationDate: Date())
            
            //Adds the food item to the food list array and deletes it from the grocery list
            //array and data source
            self.foodInstance.add(foodItem: foodItem)
            self.groceryInstance.delete(groceryItem: self.groceryList[editActionsForRowAt.row])
            tableView.deleteRows(at: [editActionsForRowAt], with: .automatic)
        }
        
        //Create a delete action
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            //Delete the row from the data source and realm
            self.groceryInstance.delete(groceryItem: self.groceryList[editActionsForRowAt.row])
            tableView.deleteRows(at: [editActionsForRowAt], with: .automatic)
            
            if self.groceryList.count == 0 {
                self.navigationItem.leftBarButtonItem?.isEnabled = false
            }
        }
        
        //Add a background color to the actions
        addToStorage.backgroundColor = UIColor(red: 143/255, green: 201/255, blue: 81/255, alpha: 1.0)
        delete.backgroundColor = .red
        //Validate the grocery list
        self.validateList()
        
        return [delete, addToStorage]
    }
    
    /**
     * Overriden function to run everytime the view appears on the
     * screen.
     */
    override func viewDidAppear(_ animated: Bool) {
        //Reload the tableview
        tableView.reloadData()
        //Validate the grocery list
        validateList()
    }
    
    /**
     * Overriden function that will run after the view
     * has been loaded to set additional properties on
     * the view controller
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get all of the grocery model objects that are saved and display our logo in the navbar
        displayLogo()
        groceryList = groceryInstance.realm.objects(GroceryModel.self)
    }

    /**
     * Overriden function that will prepare the next view controller
     * before navigation.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Check to see if this is a detail grocery item segue identifier
        if segue.identifier == "DetailGroceryItem" {
            //If so, get the path to the selected row and retrieve the grocery item
            let row = tableView.indexPathForSelectedRow?.row
            let groceryItem = groceryList[row!]
            
            //Gets the next view controller and sets its values, so the items detail can be shown
            let groceryListDetailViewController = segue.destination as! GroceryListDetailViewController
            groceryListDetailViewController.groceryItem = groceryItem
        }
    }
}

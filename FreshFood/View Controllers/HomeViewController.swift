//
//  HomeViewController.swift
//  FreshFood
//
//  Created by Brett Phillips on 3/15/18.
//  Copyright © 2018 Brett Phillips. All rights reserved.
//

import UIKit
import RealmSwift
import Photos
import UserNotifications

/**
 * Class that will display the food list to the
 * user.
 */
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //Instance variables
    var foodInstance: FoodWrapper = FoodWrapper.foodInstance
    var foodList: Results<FoodModel>!
    var rowToEdit:Int?
    
    //IBOutlet variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var storageSpace: UISegmentedControl!
    
    /**
     * IBAction that will filter the foods based
     * on the chosen storage space by the user.
     */
    @IBAction func changeStorageSpace(_ sender: UISegmentedControl) {
        filterItems(storage: sender)
    }

    /**
     * Function that will filter the food list based on
     * their respective storage space and reload the table.
     */
    func filterItems(storage: UISegmentedControl) {
        foodList = foodInstance.realm.objects(FoodModel.self).filter("storageSpace = %@", storage.titleForSegment(at: storage.selectedSegmentIndex)!)
        tableView.reloadData()
    }
    
    /**
     * Function that will get and display a
     * food image.
     */
    func setFoodImage(tbCell: UITableViewCell, foodItem: FoodModel) {
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
                var image = UIImage()
                //Request the image and assign the result to a UIImage object
                manager.requestImage(for: asset!, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                    image = result!
                })
                
                //Set the image
                tbCell.imageView?.image = image
            } else {
                //If the image was not found, then use a default image
                tbCell.imageView?.image = UIImage(named: "FreshFoodSecondaryLogo.png")
            }
        } else {
            //If the path is not a local identifier, then it references our camera roll
            //and already has a correct path
            tbCell.imageView?.image = UIImage(named: foodItem.getImage())
        }
    }
    
    /**
     * Function to determine the number of sections
     * to display in the table.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodList.count
    }
    
    /**
     * Overriden function to setup the cells that will
     * be displayed in the table.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Local variables
        //Set the reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
        let row = indexPath.row
        let item = foodList[row]

        // Configure the cell...
        //If the image is unknown, then it was just added, so make
        //the text black and set the label
        if item.getImage() == "unknown" {
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
            cell.detailTextLabel?.text = "No Expiration Date"
        }else if item.getExpirationDate() < Date() {
            //If the item has expired, then make the text red
            //and set the label
            cell.textLabel?.textColor = UIColor.red
            cell.detailTextLabel?.textColor = UIColor.red
            cell.detailTextLabel?.text = "Expired"
        } else {
            //If the item has not expired yet, then make the text black
            //and set the label
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
            //Calculate the days til expiration
            var dateDifference = Calendar.current.dateComponents([.day], from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, to: item.getExpirationDate())
            cell.detailTextLabel?.text = String(describing: dateDifference.day!)  + " Day(s) Left"
        }
        
        cell.textLabel?.text = item.getName()
        setFoodImage(tbCell: cell, foodItem: item)
        
        return cell
    }
    
    /**
     * Function to setup the table view with the ability
     * to swipe and delete an item in the array.
     */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //Check to see if the user clicked delete
        if editingStyle == .delete {
            //Delete the row from the data source, realm, and notification system
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [foodList[indexPath.row].getNotificationIdentifier()])
            foodInstance.delete(foodItem: foodList[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    /**
     * Function to make the tableview rows larger.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    /**
     * Overriden function to run everytime the view appears on the
     * screen.
     */
    override func viewWillAppear(_ animated: Bool) {
        filterItems(storage: storageSpace)
    }
    
    /**
     * Overriden function that will run after the view
     * has been loaded to set additional properties on
     * the view controller
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get all of the food model objects that are saved and display our logo in the navbar
        displayLogo()
        foodList = foodInstance.realm.objects(FoodModel.self)
    }
    
    /**
     * Overriden function that will prepare the next view controller
     * before navigation.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Check to see if this is a detail food item segue identifier
        if segue.identifier == "DetailFoodItem" {
            //If so, get the path to the selected row and retrieve the food item
            let row = tableView.indexPathForSelectedRow?.row
            let foodItem = foodList[row!]
            
            //Gets the next view controller and sets its values, so the items detail can be shown
            let homeDetailViewController = segue.destination as! HomeDetailViewController
            homeDetailViewController.foodItem = foodItem
        }
    }
}


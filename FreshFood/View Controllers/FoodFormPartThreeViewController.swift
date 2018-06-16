//
//  FoodFormPartThreeViewController.swift
//  FreshFood
//
//  Created by Brett Phillips on 3/22/18.
//  Copyright © 2018 Brett Phillips. All rights reserved.
//

import UIKit
import RealmSwift
import Photos
import UserNotifications

/**
 * Class that will control the third food form. This form
 * is responsible for adding and editing food items, specifically
 * the expiration date.
 */
class FoodFormPartThreeViewController: UIViewController {
    //Instance variables
    var foodItem: FoodModel = FoodModel()
    var storageSpace: String = ""
    var name: String = ""
    var quantity: Int = 0
    var image: UIImage = UIImage()
    var imageString: String = ""
    var foodInstance: FoodWrapper = FoodWrapper.foodInstance
    var segueIdentifier: String = ""
    var notificationIdentifier: String = ""
    
    //IBOutlet variables
    @IBOutlet weak var expirationDate: UIDatePicker!
    
    /**
     * IBAction that will add/edit a food item
     * and navigate back to the root controller.
     */
    @IBAction func add(_ sender: UIBarButtonItem) {
        //Check to see if this is an edit segue identifier
        if segueIdentifier == "EditFoodItem" {
            //If yes, then check to see if there is a different date
            if expirationDate.date != foodItem.getExpirationDate() {
                //If yes remove the prior notification
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])

                //Set a new notification
                notificationIdentifier = String(arc4random())
                
                //Update the item with the new notification
                foodInstance.update(foodItem: foodItem, storageSpace: storageSpace, name: name, quantity: quantity, image: imageString, expirationDate: expirationDate.date, notificationIdentifier: notificationIdentifier)
                
                //Set the notification
                setNotification()
            } else {
                //If no, then keep the expiration
                foodInstance.update(foodItem: foodItem, storageSpace: storageSpace, name: name, quantity: quantity, image: imageString, expirationDate: expirationDate.date)
            }
        } else {
            //Set an identifier for the notification system
            notificationIdentifier = String(arc4random())
            
            //Else, instantiate a new FoodModel object
            let foodItem = FoodModel(storageSpace: storageSpace, name: name, quantity: quantity, image: imageString, expirationDate: expirationDate.date, notificationIdentifier: notificationIdentifier)
            
            //Add the food item to the array and set the notification
            foodInstance.add(foodItem: foodItem)
            setNotification()
        }
        
        //Send the user back to the root ViewController
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /**
     * Function that will set the notification of the food item
     * to be 2 days before the food item expires.
     */
    func setNotification() {
        //Local variables
        //Get the difference in days between the current date and expiration date
        let dateDifference: DateComponents = Calendar.current.dateComponents([.day], from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, to: expirationDate.date)
        let daysTilExpiration: Int = dateDifference.day!
        var timeToNotify: Int = 0
        
        //Check to see if the difference in days is greater than 0
        //We do not want to notify the user if the item has expired already
        if dateDifference.day! > 0 {
            //If we can notify them two days in advance, then lets do it
            if (daysTilExpiration - 2) >= 2 {
                //86400 seconds in a day
                timeToNotify = (daysTilExpiration - 2) * 86400
            } else if (daysTilExpiration == 3){
                //If it expires in three days, then notify them in 1
                //Keeping consistent with notifying them two days before
                //86400 seconds in a day
                timeToNotify = 86400
            } else {
                //If the item expires in 2 days or less, then notify
                //them in a quarter of the time
                //43200 seconds in half of a day
                //21600 seconds in quarter of a day
                timeToNotify = daysTilExpiration * 21600
            }
            
            //Set the notification
            setNotificationContent(numberOfSeconds: timeToNotify, item: name)
        }
    }
    
    /**
     * Function that will set contents of the notification such as
     * the title, description etc.
     */
    func setNotificationContent(numberOfSeconds: Int, item: String) {
        //Set the notification trigger and content objects
        let notificationTime = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(numberOfSeconds), repeats: false)
        let notificationContent = UNMutableNotificationContent()
        var correctGrammer: String = ""

        //Set the title of the notification
        notificationContent.title = "FreshFood"
        //For correct grammer check to see if the item is plural
        if item.lowercased().last! == "s" {
            correctGrammer = " are"
        } else {
            correctGrammer = " is"
        }
        
        //Construct the body of the message referring to the item, storage space, and quantity
        let bodyOne = "The " + item + " in your " + storageSpace.lowercased() + correctGrammer + " about to expire and you have "
        let bodyTwo = String(quantity) + " left. Hurry up and eat it!"
        //Concatenate the two strings and assign it as the body of the notification
        notificationContent.body = bodyOne + bodyTwo
        //Add a default sound
        notificationContent.sound = UNNotificationSound.default()
        
        //Create the notification request object
        let notificationRequest = UNNotificationRequest(identifier: notificationIdentifier, content: notificationContent, trigger: notificationTime)
        
        //Add the full notification to the user's notifications
        UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: nil)
    }
    
    /**
     * Function that will set up the ViewController with
     * the necessary values.
     */
    func initialSetUp() {
        //Check to see if this is an edit segue identifier
        if segueIdentifier == "EditFoodItem" {
            //Set the expiration date and notification identifier for the food item
            expirationDate.date = foodItem.getExpirationDate()
            notificationIdentifier = foodItem.getNotificationIdentifier()
            
            //Change the button to "Update"
            self.navigationItem.rightBarButtonItem?.title = "Update"
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
        //Setup the ViewController
        initialSetUp()
    }
}

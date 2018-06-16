//
//  FoodWrapper.swift
//  FreshFood
//
//  Created by Brett Phillips on 3/22/18.
//  Copyright © 2018 Brett Phillips. All rights reserved.
//

import Foundation
import RealmSwift

/**
 * Model wrapper class for passing around the list
 * of food items. This serves as a singleton, so
 * any object can access its variables
 */
class FoodWrapper: NSObject {
    //Instance variables
    static let foodInstance = FoodWrapper()
    let realm = try! Realm()
    
    private override init() {}
    
    /**
     * Function that will add a food item.
     */
    func add(foodItem: FoodModel) {
        try! realm.write {
            realm.add(foodItem)
        }
    }
    
    /**
     * Function that will update a food item
     */
    func update(foodItem: FoodModel, storageSpace: String, name: String, quantity: Int, image: String, expirationDate: Date) {
        try! realm.write {
            foodItem.set(storageSpace: storageSpace)
            foodItem.set(name: name)
            foodItem.set(quantity: quantity)
            foodItem.set(image: image)
            foodItem.set(expirationDate: expirationDate)
        }
    }
    
    /**
     * Function that will update a food item with a notification
     * identifier.
     */
    func update(foodItem: FoodModel, storageSpace: String, name: String, quantity: Int, image: String, expirationDate: Date, notificationIdentifier: String) {
        try! realm.write {
            foodItem.set(storageSpace: storageSpace)
            foodItem.set(name: name)
            foodItem.set(quantity: quantity)
            foodItem.set(image: image)
            foodItem.set(expirationDate: expirationDate)
            foodItem.set(notificationIdentifier: notificationIdentifier)
        }
    }
    
    /**
     * Function that will delete a food item.
     */
    func delete(foodItem: FoodModel) {
        try! realm.write {
            realm.delete(foodItem)
        }
    }
}

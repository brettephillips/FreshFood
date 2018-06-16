//
//  FoodModel.swift
//  FreshFood
//
//  Created by Brett Phillips on 3/22/18.
//  Copyright © 2018 Brett Phillips. All rights reserved.
//

import Foundation
import RealmSwift

/**
 * Class that will model a food item
 */
class FoodModel: Object {
    //Instance variables
    @objc dynamic var storageSpace = ""
    @objc dynamic var name = ""
    @objc dynamic var quantity = 1
    @objc dynamic var image = ""
    @objc dynamic var expirationDate = Date()
    @objc dynamic var notificationIdentifier = ""
    
    //Convenience Initializer
    convenience init(storageSpace: String, name: String, quantity: Int, image: String, expirationDate: Date, notificationIdentifier: String) {
        self.init()
        self.set(storageSpace: storageSpace)
        self.set(name: name)
        self.set(quantity: quantity)
        self.set(image: image)
        self.set(expirationDate: expirationDate)
        self.set(notificationIdentifier: notificationIdentifier)
    }
    
    //Accessors
    func getStorageSpace() -> String {
        return storageSpace
    }
    
    func getName() -> String {
        return name
    }
    
    func getQuantity() -> Int {
        return quantity
    }
    
    func getImage() -> String {
        return image
    }
    
    func getExpirationDate() -> Date {
        return expirationDate
    }
    
    func getNotificationIdentifier() -> String {
        return notificationIdentifier
    }
    
    //Mutators
    func set(storageSpace: String) {
        self.storageSpace = storageSpace
    }
    
    func set(name: String) {
        self.name = name
    }
    
    func set(quantity: Int) {
        self.quantity = quantity
    }
    
    func set(image: String) {
        self.image = image
    }
    
    func set(expirationDate: Date) {
        self.expirationDate = expirationDate
    }
    
    func set(notificationIdentifier: String) {
        self.notificationIdentifier = notificationIdentifier
    }
}

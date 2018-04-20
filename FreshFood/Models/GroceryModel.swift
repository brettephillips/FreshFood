//
//  GroceryModel.swift
//  FreshFood
//
//  Created by Brett Phillips on 3/22/18.
//  Copyright © 2018 Brett Phillips. All rights reserved.
//

import Foundation
import RealmSwift

/**
 * Class that will model a grocery item
 */
class GroceryModel: Object {
    //Instance variables
    @objc dynamic var storageSpace = ""
    @objc dynamic var name = ""
    @objc dynamic var quantity = 1
    
    //Convenience Initializer
    convenience init(storageSpace: String, name: String, quantity: Int) {
        self.init()
        self.set(storageSpace: storageSpace)
        self.set(name: name)
        self.set(quantity: quantity)
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
}

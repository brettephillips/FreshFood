//
//  GroceryWrapper.swift
//  FreshFood
//
//  Created by Brett Phillips on 3/22/18.
//  Copyright © 2018 Brett Phillips. All rights reserved.
//

import Foundation
import RealmSwift

/**
 * Model wrapper class for passing around the list
 * of grocery items. This serves as a singleton, so
 * any object can access its variables.
 */
class GroceryWrapper: NSObject {
    //Instance variables
    static let groceryInstance = GroceryWrapper()
    let realm = try! Realm()
    
    private override init() {}
    
    /**
     * Function that will add a grocery item
     */
    func add(groceryItem: GroceryModel) {
        try! realm.write {
            realm.add(groceryItem)
        }
    }
    
    /**
     * Function that will update a grocery item
     */
    func update(groceryItem: GroceryModel, storageSpace: String, name: String, quantity: Int) {
        try! realm.write {
            groceryItem.set(storageSpace: storageSpace)
            groceryItem.set(name: name)
            groceryItem.set(quantity: quantity)
        }
    }
    
    /**
     * Function that will delete a grocery item
     */
    func delete(groceryItem: GroceryModel) {
        try! realm.write {
            realm.delete(groceryItem)
        }
    }
}

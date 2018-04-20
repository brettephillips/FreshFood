//
//  AppDelegate.swift
//  FreshFood
//
//  Created by Brett Phillips on 3/15/18.
//  Copyright © 2018 Brett Phillips. All rights reserved.
//

import UIKit
import UserNotifications
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //Instance variables
    var window: UIWindow?
    
    /**
     * Function that will ask for authorization for
     * notifications as well as using the user's photo
     * library.
     */
    func getAuthorization() {
        //Request authorization for notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            (success, error) in
            if error != nil {
                print("No access/error")
            } else {
                print("success")
            }
        }
        
        //Request authorization for the photo library
        PHPhotoLibrary.requestAuthorization { (status) in
            print(status)
        }
    }
    
    /**
     * Function that will make the text on the navigation
     * bar white.
     */
    func navigationTextColor() {
        UINavigationBar.appearance().tintColor = UIColor.white
    }

    /**
     * Function that will customize the application after
     * the application launches
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Get authorization and set the navigation bar text
        getAuthorization()
        navigationTextColor()
        
        return true
    }
}

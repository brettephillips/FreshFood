//
//  CommonMethods
//  FreshFood
//
//  Created by Brett Phillips on 4/20/18.
//  Copyright © 2018 Brett Phillips. All rights reserved.
//

import UIKit

/**
 * An extension to UIViewController
 */
extension UIViewController {
    func displayLogo() {
        //Programmatically add a logo (image) to the navigation bar
        let titleImage = UIImageView(image: UIImage(named: "FreshFoodSecondaryLogo.png"))
        titleImage.contentMode = .scaleAspectFit
        let navbarView = UIView(frame: CGRect(x: 0, y: 0, width: 33, height: 35))
        titleImage.frame = navbarView.bounds
        navbarView.addSubview(titleImage)
        self.navigationItem.titleView = navbarView
    }
}

/**
 * Enum that will be used to access the storage
 * space values.
 */
enum StorageSpace: Int {
    case FREEZER_STORAGE_SPACE = 0
    case FRIDGE_STORAGE_SPACE = 1
    case PANTRY_STORAGE_SPACE = 2
}

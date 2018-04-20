//
//  FoodFormPartTwoViewController.swift
//  FreshFood
//
//  Created by Brett Phillips on 3/22/18.
//  Copyright © 2018 Brett Phillips. All rights reserved.
//

import UIKit
import Photos

/**
 * Class that will control the second food form. This form
 * is responsible for adding and editing food items, specifically
 * the food image.
 */
class FoodFormPartTwoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Instance variables
    var foodItem: FoodModel = FoodModel()
    var imageController: UIImagePickerController = UIImagePickerController()
    var isLibraryImage: Bool = false
    var imagePath: String = "unknown"
    var storageSpace: String = ""
    var name: String = ""
    var quantity: Int = 0
    var segueIdentifier: String = ""
    
    //IBOutlet variables
    @IBOutlet weak var image: UIImageView!
    
    /**
     * IBAction that will alet the user, prompting them to
     * choose an image from their camera roll or take
     * on themselves.
     */
    @IBAction func chooseImage(_ sender: UIButton) {
        //Create the alert controller and the actions associated with it
        let alertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) {(action ) in
            self.useCamera()
        }
        let libraryAction = UIAlertAction(title: "Library", style: .default) {(action ) in
            self.usePhotoLibrary()
        }
        
        //Add the actions
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        
        //Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    /**
     * Function that will present the camera
     * if available.
     */
    func useCamera() {
        //Check to see if the phone has a camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //We are not grabbing an image from the library, so set this to false
            isLibraryImage = false
            //Set the image controller properties
            imageController.delegate = self
            imageController.sourceType = .camera
            imageController.allowsEditing = false
            //Present the image controller
            self.present(imageController, animated: true, completion: nil)
        }
    }
    
    /**
     * Function that will present the camera
     * roll if available.
     */
    func usePhotoLibrary() {
        //Check to see if the phone has a camera roll
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //We are grabbing an image from the library, so set this to true
            isLibraryImage = true
            //Set the image controller properties
            imageController.delegate = self
            imageController.sourceType = .photoLibrary
            imageController.allowsEditing = false
            //Present the image controller
            self.present(imageController, animated: true, completion: nil)
        }
    }
    
    /**
     * Function that will run once the image has been
     * chosen.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Get the image that was chosen
        let imageChosen = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //If the user took their own image, then we need to save their image
        if isLibraryImage == false {
            UIImageWriteToSavedPhotosAlbum(imageChosen, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            //Else, we can just get the path to the image in the library
            let imageURL = info[UIImagePickerControllerImageURL] as! NSURL
            imagePath = imageURL.path!
        }
        
        //Assign it to the imageView, so the user can see it and dismiss the image picker controller
        image.image = imageChosen
        dismiss(animated: true, completion: nil)
    }
    
    /**
     * Function that will run once the image has been
     * saved to the users camera roll.
     */
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        //Set the fetch options
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        //Fetch the image with the last creation date
        //This should be the image we just saved
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        //If we are able to get the object, then store it's local identifier for later use
        if fetchResult.firstObject != nil {
            let lastImageAsset = fetchResult.firstObject
            imagePath = "Identifier:" + (lastImageAsset?.localIdentifier)!
        }
    }
    
    /**
     * Function that will get and display a
     * food image.
     */
    func getFoodImage() {
        //Check to see if this is an edit segue identifier
        if segueIdentifier == "EditFoodItem" {
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
                    var imageFound = UIImage()
                    //Request the image and assign the result to a UIImage object
                    manager.requestImage(for: asset!, targetSize: CGSize(width: 3024.0, height: 4032.0), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                        imageFound = result!
                    })
                    
                    //Set the image and image path
                    image.image = imageFound
                    imagePath = foodItem.getImage()
                } else {
                    //If the image was not found, then use a default image
                    image.image = UIImage(named: "FreshFoodSecondaryLogo.png")
                    imagePath = "FreshFoodSecondaryLogo.png"
                }
            } else {
                //If the path is not a local identifier, then it references our camera roll
                //and already has a correct path
                image.image = UIImage(named: foodItem.getImage())
                imagePath = foodItem.getImage()
            }
            
            //Enable the button to continue
            self.navigationItem.rightBarButtonItem?.isEnabled = true
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
        //Gets the food image to be displayed to the user upon load
        getFoodImage()
    }
    
    /**
     * Overriden function that will prepare the next view controller
     * before navigation.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Gets the next view controller and sets its values, so they can be saved at the end of the form
        let foodFormPartThree = segue.destination as! FoodFormPartThreeViewController
        foodFormPartThree.storageSpace = storageSpace
        foodFormPartThree.name = name
        foodFormPartThree.quantity = quantity
        foodFormPartThree.foodItem = foodItem
        
        //If the user did not choose an image, then use a default image
        if imagePath == "unknown" {
            foodFormPartThree.image = UIImage(named: "FreshFoodSecondaryLogo.png")!
            foodFormPartThree.imageString = "FreshFoodSecondaryLogo.png"
        } else {
            //Else we can set the image
            foodFormPartThree.image = image.image!
            foodFormPartThree.imageString = imagePath
        }
        
        //Check to see if this is an edit segue identifier
        if segueIdentifier == "EditFoodItem" {
            //If so, then pass the food item as well and the segue identifier
            //we will reference this later to update the object through realm
            foodFormPartThree.foodItem = foodItem
            foodFormPartThree.segueIdentifier = "EditFoodItem"
        }
    }
}

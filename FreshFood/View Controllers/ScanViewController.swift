//
//  ScanViewController.swift
//  FreshFood
//
//  Created by Brett Phillips on 3/15/18.
//  Copyright © 2018 Brett Phillips. All rights reserved.
//

import UIKit
import AVFoundation

/**
 * Class that will scan a barcode and retrieve the food
 * item for the user to add.
 */
class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    //Instance variables
    var captureSession: AVCaptureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice!
    var captureVideoPrevLayer: AVCaptureVideoPreviewLayer!
    var captureRectangle: UIView!
    var scannedItem: String!
    var didAlert: Bool = false
    
    /**
     * Function that will check to see if the session
     * capture is running and run it if not.
     */
    func checkSession() {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    /**
     * Overriden function to run everytime the view appears on the
     * screen.
     */
    override func viewDidAppear(_ animated: Bool) {
        checkSession()
    }
    
    /**
     * Function that will set up the ViewController with
     * the necessary values.
     */
    func initialSetUp() {
        //Set the input capture device to video and add it to the capture session
        captureDevice = AVCaptureDevice.default(for: .video)
        let captureInput = try? AVCaptureDeviceInput(device: captureDevice)
        captureSession.addInput(captureInput!)
        //Set the output capture to metadata and add it to the capture session
        let captureOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureOutput)
        //Set the delegate for the metadata and the metadata object types to retrieve
        //Metadata object types are different barcode types
        captureOutput.setMetadataObjectsDelegate(self, queue: .main)
        captureOutput.metadataObjectTypes = [.upce, .ean13, .ean8]
        //Check to see if the session is running
        //At this time it should not be, so it will start
        checkSession()
        //Allows us to preview the video (layer) while we are capturing data
        captureVideoPrevLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //Sets the bounds of the layer and adds it to the view
        captureVideoPrevLayer.videoGravity = .resizeAspectFill
        captureVideoPrevLayer.frame = view.layer.bounds
        view.layer.addSublayer(captureVideoPrevLayer)
    }
    
    /**
     * Function that will fetch the barcode from the API
     * and present the findings to the user.
     */
    func getBarcodeData(barcodeValue: String) {
        //The endpoint that needs to be hit
        let endpoint = URL(string: "https://world.openfoodfacts.org/api/v0/product/" + barcodeValue + ".json")
        //Get the data from the endpoint
        let data = try? Data(contentsOf: endpoint!)
        
        //Try to serialize the json
        if let json = (try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)) as? [String: Any] {
            //Check to see if the product was found
            if json["status_verbose"] as! String == "product found" {
                //If so, get the product
                if let product = json["product"] as? [String: Any] {
                    //Try to get the item
                    if let foodName = product["product_name_en"] as? String {
                        //If we were able to get the item then set didAlert to false
                        //Assign the food to the scanned item
                        didAlert = false
                        scannedItem = foodName
                        
                        //Make sure the scanned item isnt blank
                        if scannedItem == "" {
                            //If it is, then tell the user we cannot find the item
                            alert()
                        } else {
                            //If we have the item stop the session capture and perform the necessary segue
                            captureSession.stopRunning()
                            performSegue(withIdentifier: "barcodeScanner", sender: nil)
                        }
                    } else {
                        //If we cant find the item alert the user
                        alert()
                    }
                }
            } else {
                //If the product was not found, then alert the user
                alert()
            }
        }
    }

    /**
     * Function that will run during the barcode scanning.
     */
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //If we did not retrieve any items, then just return
        if metadataObjects.count == 0 {
            return
        }
        
        //If we received an object then set the variable
        let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        //Decode the metadata into a readable string
        if let codeValue = metadataObject.stringValue {
            //Vibrate the device to let the user know the barcode was finished reading
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            //Get the barcode data
            getBarcodeData(barcodeValue: codeValue)
        } else {
            //If we cannot decode the barcode, then just return
            return
        }
    }
    
    /**
     * Function that will run alert the user, letting
     * them know we could not find the food item.
     */
    func alert() {
        //Stop the capture and set didAlert to true
        captureSession.stopRunning()
        didAlert = true
        
        //Create the alert controller and the actions associated with it
        let alertController = UIAlertController(title: "Barcode Scanner", message: "Sorry, but we could not find your item at this time. Please enter it manually or try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {(action ) in
            self.performSegue(withIdentifier: "barcodeScanner", sender: nil)
        }
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) {(action ) in
            self.checkSession()
        }
        
        //Add the actions
        alertController.addAction(tryAgainAction)
        alertController.addAction(okAction)
        
        //Present the alert controller
        self.present(alertController, animated: true, completion: nil)
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
        //Set up the view controller
        initialSetUp()
    }
    
    /**
     * Overriden function that will prepare the next view controller
     * before navigation.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Gets the next view controller and sets its values, so they can be saved at the end of the form
        let foodFormPartOneController = segue.destination as! FoodFormPartOneViewController
        
        //Check to see if the user was alerted
        if !didAlert {
            //Set the segue identifier and pass the scanned item to the next view controller so that the item
            //can be saved
            foodFormPartOneController.segueIdentifier = "barcodeScanner"
            foodFormPartOneController.scannedItem = scannedItem
        }
    }
}


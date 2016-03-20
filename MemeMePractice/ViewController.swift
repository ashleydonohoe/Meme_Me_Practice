//
//  ViewController.swift
//  MemeMePractice
//
//  Created by Gabriele on 3/19/16.
//  Copyright © 2016 Ashley Donohoe. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: 4.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    // Presents Image Picker to user
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    
    // Allows user to pick image from camera
    @IBAction func pickFromCamera(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // Sets the picked image to be in the Image View
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Allows user to share meme to social media, send via email, etc
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let image = imagePickerView.image
        let controller = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func userStartedEditing(sender: UITextField) {
        topText.text = ""
        bottomText.text = ""
    }
    
    // Clears default text begins editing text field
    func textFieldDidBeginEditing(textField: UITextField) {
            topText.text = ""
            bottomText.text = ""
    }
    
    // TODO: When a user presses return, the keyboard should be dismissed. This can be accomplished in textFieldShouldReturn.
    
    
}


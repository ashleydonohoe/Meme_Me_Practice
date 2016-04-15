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
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var navbar: UINavigationBar!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    var memedImage: UIImage!
    
    // Dictionary to hold text attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -4.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.enabled = false
        
        setUpText(topText, text: "TOP")
        setUpText(bottomText, text: "BOTTOM")
    }
    
    
    // Sets text, text attributes, text alignment, and delegate to self for both text fields
    func setUpText(textField: UITextField, text: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = text
        textField.textAlignment = .Center
        textField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func clearMeme(sender: AnyObject) {
        //TODO: Clear meme image and text fields
        imagePickerView.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
    }
    
    // Presents Image Picker to user
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
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
        
        shareButton.enabled = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Generate the memed image
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        navbar.hidden = true
        toolbar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navbar.hidden = false
        toolbar.hidden = false
        
        return memedImage
    }
    
   func save() {
        let meme = Meme(topText: topText.text!, bottomtext: bottomText.text!, image: imagePickerView.image!, memedImage: memedImage!)
        print(meme)
    }
    
    // Clears placeholder text from screen when user taps inside a textfield
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.becomeFirstResponder()
        
        // Checks top and bottom text to see if it's been changed
        if textField.text != "TOP" || textField.text != "BOTTOM" {
            textField.text = ""
        }
        
        // Checks if active textField is the bottomText. If so, the keyboard will move up. Else, keyboard notifications won't be subscribed to. This code is needed so the top field doesn't make the keyboard move up and hide the field from view.
        if textField.isEqual(bottomText) {
            subscribeToKeyboardNotifications()
        } else {
            unsubscribeFromKeyboardNotifications()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Allows user to share meme to social media, send via email, etc
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(controller, animated: true, completion: nil)
    }
    
    // Moves the view when keyboard covers text field
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    /*
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
 */
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Hiding keyboard
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
}


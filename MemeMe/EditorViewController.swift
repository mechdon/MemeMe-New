//
//  ViewController.swift
//  MemeMe
//
//  Created by Gerard Heng on 12/5/15.
//  Copyright (c) 2015 gLabs. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    // Outlets for imageView, buttons, labels and toolbar
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    // Declare variable for UIImage
    var memedImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Disable shareButton when view is first loaded
        shareButton.enabled = false
        
        
        //# MARK: - Text Settings
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -2.0
        ]
        
        // Set Text Font
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        // Align Text
        topText.textAlignment = NSTextAlignment.Center;
        bottomText.textAlignment = NSTextAlignment.Center;
        
        // Set Initial Text
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        // Set delegates for top and bottom labels
        self.topText.delegate = self
        self.bottomText.delegate = self
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    override func viewWillAppear(animated: Bool) {
        
        // Enable Camera Button only when it is available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) as Bool
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeFromKeyboardNotifications()
    }
    
    
    //# MARK: - Image Picker Methods
    
    // Pick Image from Album
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // Pick Image from Camera
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    // Image picked
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
            imagePickerView.image = image
            shareButton.enabled = true
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Image Picker Cancelled
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Erase original text once textfield begins editing
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    //# MARK: - Keyboard functions
    
    // Textfield resigns first responder when return key is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // Move the view when the keyboard covers the text field
    func keyboardWillShow(notification: NSNotification) {
        if (bottomText.isFirstResponder()){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Hide Keyboard
    func keyboardWillHide(notification: NSNotification) {
        if (bottomText.isFirstResponder()){
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    // Get height of keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // Subscribe to keyboard notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    // Unsubscribe from keyboard notifications
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Save Meme
    func save() {
        
        // Update the Meme
        var meme = Meme(top: topText.text!, bottom: bottomText.text!, image: imagePickerView.image!, memedImage: self.memedImage)
        
        // Add it to the memes array on the Application Delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    // Reset view
    func resetView() {
        self.imagePickerView.image = nil
        self.shareButton.enabled = false
        self.topText.text = "TOP"
        self.bottomText.text = "BOTTOM"
    }
    
    // Generate Meme Image
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        if self.navigationController != nil {
            self.navigationController?.navigationBar.hidden = true
        }
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        if self.navigationController != nil {
            self.navigationController?.navigationBar.hidden = false
        }
        toolBar.hidden = false
        
        // return rendered image
        return memedImage
    }
    
    // Cancel button pressed
    @IBAction func cancelButton(sender: AnyObject) {
        self.resetView()
    }
    
    // Share button pressed
    @IBAction func shareMeme(sender: AnyObject) {
        
        memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activityType, completion, objects, error) -> Void in
            if completion {
                self.save()
                self.resetView()
                self.performSegueWithIdentifier("showSentView", sender: self)
        }
    }
    self.presentViewController(activityViewController, animated: true, completion: nil)
    
    }

}


//
//  AddBookViewController.swift
//  The-Prolific-Library
//
//  Created by Diego Urquiza on 9/9/15.
//  Copyright © 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController {

    // MARK: Instance Properties
    
    @IBOutlet weak var bookTitleTextField: UITextField!
    @IBOutlet weak var authorNameTextField: UITextField!
    @IBOutlet weak var publisherNameTextField: UITextField!
    @IBOutlet weak var categoriesTextField: UITextField!
    
    
    
    // MARK: Instance Methods

    ///If all textfields are empty dismiss ViewController. Otherwise warn the user.
    @IBAction func checkIfUserIsDone(sender: AnyObject) {
        
        if areAllTextFieldsEmpty() {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            displayDoneAlert()
        }
        
    }
    
    ///Checks if all textfields are empty
    func areAllTextFieldsEmpty() -> Bool {
        
        if errorChecking.isStringEmpty(bookTitleTextField.text) && errorChecking.isStringEmpty(authorNameTextField.text) && errorChecking.isStringEmpty(publisherNameTextField.text) && errorChecking.isStringEmpty(categoriesTextField.text){
            return true
        } else {
            return false
        }
    }
    
    ///Display a warning alert and dismiss ViewController if the user accepts warning message.
    func displayDoneAlert() {
        
        let alertView = UIAlertController(title: alertMessage.warningTitleMessage, message: alertMessage.areYouDoneTextBody, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: alertMessage.yesString, style: UIAlertActionStyle.Default, handler: { (_) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
        }))
        alertView.addAction(UIAlertAction(title: alertMessage.noString, style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alertView, animated: true, completion: nil)
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

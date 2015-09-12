//
//  BookDetailsViewController.swift
//  The-Prolific-Library
//
//  Created by Diego Urquiza on 9/11/15.
//  Copyright © 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class BookDetailsViewController: UIViewController {

    
    // MARK: - Instance Properties
    
    var book:Book!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var checkedOutLabel: UILabel!
    
    
    // MARK: - Instance Methods
    
    
    // MARK: Checkout Book Logic
    
    @IBAction func checkoutCurrentBook(sender: AnyObject) {
        promptUserForName()
    }
    
    func promptUserForName() {
        
        let alertView = UIAlertController(title: alertMessage.checkoutTitle, message: alertMessage.whoIsUser, preferredStyle: UIAlertControllerStyle.Alert)
        
        var usernameTextField:UITextField?
        alertView.addTextFieldWithConfigurationHandler { (textField) -> Void in
            usernameTextField = textField
        }
        
        alertView.addAction(UIAlertAction(title: alertMessage.sumbit, style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            
            if let username = usernameTextField!.text {
                self.checkoutBookWithName(username)
            } else {
                errorHandlingHelper.generalErrorAlert(self)
            }
            
        }))
        
        alertView.addAction(UIAlertAction(title: alertMessage.cancel, style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alertView, animated: true, completion: nil)
        
    }
    
    
    func checkoutBookWithName(username: String) {
        
        if errorHandlingHelper.isStringEmpty(username) {
            displayEmptyUsernameAlert()
        } else {
            ProgressHelper.startLoadAnimationAndDisableUI(self)
            book.checkoutBook(username, completionBlock: { (success) -> Void in
                if success {
                    self.displayAlertSuccessfulCheckout()
                } else {
                    errorHandlingHelper.generalErrorAlert(self)
                }
                ProgressHelper.reEnableUI(self)
            })
        }
        
    }
    
    func displayAlertSuccessfulCheckout() {
        
        let alertView = UIAlertController(title: alertMessage.successTitle, message: alertMessage.bookCheckedOutMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: alertMessage.ok, style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    func displayEmptyUsernameAlert () {
        
        let alertView = UIAlertController(title: alertMessage.warningTitleMessage, message: alertMessage.missingUsername, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: alertMessage.ok, style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    // MARK: Edit Current Book Logic
    
    @IBAction func editCurrentBookInformation(sender: AnyObject) {
    }
    
    
    // MARK: Share Book via FB and Twitter
    
    @IBAction func shareLink(sender: AnyObject) {
    }
    
    
    // MARK: View Setup Logic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLabels()
    }

    func setUpLabels () {
        
        titleLabel.text = book.jsonDictionary["title"]
        authorLabel.text = book.jsonDictionary["author"]
        publisherLabel.text = "Publisher: " + book.jsonDictionary["publisher"]!
        categoryLabel.text =  "Tags: " + book.jsonDictionary["categories"]!
        
        if wasBookEverCheckedOut() {
            
            checkedOutLabel.text = "Last Checked Out: " + book.jsonDictionary["lastCheckedOutBy"]! + " @ " + formatDateFromServer()
        } else {
            checkedOutLabel.text = "Last Checked Out: Has not been checked out."
        }
   
    }
    
    func formatDateFromServer() -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date:NSDate = dateFormatter.dateFromString(book.jsonDictionary["lastCheckedOut"]!)!
        
        let newDateForm = NSDateFormatter()
        newDateForm.dateFormat = "MMMM d, yyy h:mma"
        
        return newDateForm.stringFromDate(date)
    }
    
    func wasBookEverCheckedOut() -> Bool {
        
        if errorHandlingHelper.isStringEmpty(book.jsonDictionary["lastCheckedOutBy"]) && errorHandlingHelper.isStringEmpty(book.jsonDictionary["lastCheckedOut"]) {
            
            return false
        } else {
            return true
        }
    }
    
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editBook" {
            
            let bookEditView = segue.destinationViewController as! AddBookViewController
            bookEditView.bookToEditUrl = book.jsonDictionary["url"]
            bookEditView.currentRequest = .PUT
            bookEditView.bookToEditData = book
            
        }
    }
    

}

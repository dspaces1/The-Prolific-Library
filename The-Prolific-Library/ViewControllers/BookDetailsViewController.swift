//
//  BookDetailsViewController.swift
//  The-Prolific-Library
//
//  Created by Diego Urquiza on 9/11/15.
//  Copyright © 2015 Diego Urquiza. All rights reserved.
//

import UIKit
import Social

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
    
    /// Ask user for username to attach with checkout field
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
    
    /// Put request to the server with user
    func checkoutBookWithName(username: String) {
        
        if errorHandlingHelper.isStringEmpty(username) {
            displayEmptyUsernameAlert()
        } else {
            ProgressHelper.enableUI(false, currentView: self)
            book.checkoutBook(username, completionBlock: { (success) -> Void in
                if success {
                    self.displayAlertSuccessfulCheckout()
                } else {
                    errorHandlingHelper.couldNotConnectToServerAlert(self, titleMessage: alertMessage.errorTitle, bodyMessage: alertMessage.couldNotConnectToServerMessage)
                }
                ProgressHelper.enableUI(true, currentView: self)
            })
        }
        
    }
    
    /// Display a succesfully posted alert
    func displayAlertSuccessfulCheckout() {
        
        let alertView = UIAlertController(title: alertMessage.successTitle, message: alertMessage.bookCheckedOutMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: alertMessage.ok, style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    /// Display an error that the user entered a blank username field
    func displayEmptyUsernameAlert () {
        
        let alertView = UIAlertController(title: alertMessage.warningTitleMessage, message: alertMessage.missingUsername, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: alertMessage.ok, style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    
    // MARK: Share Book via FB and Twitter
    
    @IBAction func shareLink(sender: AnyObject) {
        displayShareAlert()
    }
    
    func displayShareAlert() {
        let alertView = UIAlertController(title: alertMessage.shareContentTitle, message: alertMessage.shareContentMessage , preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: alertMessage.facebookTitle, style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            self.shareWithFacebook()
        }))
        
        alertView.addAction(UIAlertAction(title: alertMessage.twitterTitle, style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            self.shareWithTwitter()
        }))
        
        alertView.addAction(UIAlertAction(title: alertMessage.cancel, style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    /// Share book information with facebook
    func shareWithFacebook() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText(composeBookInformationToShare())
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: alertMessage.accountTitle, message: alertMessage.accountMessagefb, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: alertMessage.ok, style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    /// Share book information with twitter
    func shareWithTwitter() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText(composeBookInformationToShare())
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: alertMessage.accountTitle, message: alertMessage.accountMessagetwitter, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: alertMessage.ok, style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /// Put all book information into one message
    func composeBookInformationToShare () -> String {
        let shareMessage: String = "Check out this book from our library: \n\(titleLabel.text!)\n\(authorLabel.text!)\n\(publisherLabel.text!)\n\(categoryLabel.text!)\n\(checkedOutLabel.text!)"
        return shareMessage
    }
    
    // MARK: View Setup Logic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLabels()
    }

    /// Grab all relevant JSON fields and display them in labels
    func setUpLabels () {
        
        titleLabel.text = book.bookName
        authorLabel.text = book.authorName
        publisherLabel.text = "Publisher: " + book.publisherName
        categoryLabel.text =  "Tags: " + book.categoryNames
        
        if wasBookEverCheckedOut() {
            
            checkedOutLabel.text = "Last Checked Out: " + book.checkoutPersonsName + " @ " + book.formatDateFromServer()
        } else {
            checkedOutLabel.text = "Last Checked Out: Has not been checked out."
        }
   
    }
    
    
    
    /// Check JSON data for a blank string to see if a user has checked out book
    func wasBookEverCheckedOut() -> Bool {
        
        if errorHandlingHelper.isStringEmpty(book.checkoutPersonsName) && errorHandlingHelper.isStringEmpty(book.checkoutTime) {
            
            return false
        } else {
            return true
        }
    }
    
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editBook" {
            
            let bookEditView = segue.destinationViewController as! AddBookViewController
            bookEditView.bookToEditUrl = book.bookUrl
            bookEditView.currentRequest = .editBook
            bookEditView.bookToEditData = book
            
        }
    }

}

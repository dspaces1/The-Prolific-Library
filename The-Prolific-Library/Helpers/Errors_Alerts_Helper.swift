//
//  Errors_Alerts_Helper.swift
//  The-Prolific-Library
//
//  Created by Diego Urquiza on 9/9/15.
//  Copyright © 2015 Diego Urquiza. All rights reserved.
//

import UIKit


class alertMessage {
    
    static let errorTitle: String = "Error"
    static let couldNotConnectToServerMessage: String = "Could not connect to server. Please check network connection and try again."
    static let somethingWentWrongError: String = "Something went wrong. Please try again or restart app."
    
    static let successTitle: String = "Success"
    static let deletedEntireLibraryMessage: String = "Deleted entire library."
    
    static let missingBookOrAuthorFieldsMessage: String = "Book Title and Author are required fields"
    static let ok = "Ok"
    
    static let warningTitleMessage: String = "Warning"
    static let areYouDoneTextBody: String = "Any information you entered will not be saved. Are you sure you want to exit?"
    static let deleteEntireLibraryWarning: String = "Are you sure you would like to delete the entire Library? If you do, all book information will be destroyed."
    static let missingUsername: String = "Cannot checkout book with empty name. Please try again."
    
    static let yesString: String = "Yes"
    static let noString: String = "No"
    
    static let checkoutTitle: String = "Checkout"
    static let whoIsUser: String = "Please enter name to checkout book."
    static let sumbit: String = "Submit"
    static let cancel: String = "Cancel"
    

}


class errorHandlingHelper {
    

    // MARK: Class Methods
    
    static func couldNotConnectToServerAlert (currentView: UIViewController, titleMessage: String, bodyMessage: String) {
        
        let alertView = UIAlertController(title: titleMessage, message: bodyMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: alertMessage.ok, style: UIAlertActionStyle.Default, handler: nil))
        
        currentView.presentViewController(alertView, animated: true, completion: nil)
    }
    
    static func generalErrorAlert (currentView: UIViewController) {
        
        let alertView = UIAlertController(title: alertMessage.errorTitle, message: alertMessage.somethingWentWrongError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: alertMessage.ok, style: UIAlertActionStyle.Default, handler: nil))
        
        currentView.presentViewController(alertView, animated: true, completion: nil)
    }
    
    /**
    Check to see if a string is empty or blank spaces with no leading characters
    
    - parameter stringToCheck: any string
    - returns: true if the string is emtpy
    */
    static func isStringEmpty( stringToCheck: String?) -> Bool  {

        if let string = stringToCheck {

            let trimString = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            return trimString.isEmpty
        }
        
        return true
    }
    
}




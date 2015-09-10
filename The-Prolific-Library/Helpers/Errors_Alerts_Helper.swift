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
    
    static let successTitle: String = "Success"
    
    static let missingBookOrAuthorFieldsMessage: String = "Book Title and Author are required fields"
    static let ok = "Ok"
    
    static let warningTitleMessage: String = "Warning"
    static let areYouDoneTextBody: String = "Any information you entered will not be saved. Are you sure you want to exit?"
    static let yesString: String = "Yes"
    static let noString: String = "No"
}


class errorHandlingHelper {
    

    // MARK: Class Methods
    
    static func couldNotConnectToServerAlert (currentView: UIViewController, titleMessage: String, bodyMessage: String) {
        
        let alertView = UIAlertController(title: titleMessage, message: bodyMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
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




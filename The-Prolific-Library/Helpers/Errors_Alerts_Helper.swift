//
//  Errors_Alerts_Helper.swift
//  The-Prolific-Library
//
//  Created by Diego Urquiza on 9/9/15.
//  Copyright © 2015 Diego Urquiza. All rights reserved.
//

import UIKit


class alertMessage {
    
    static let missingBookOrAuthorFieldsMessage: String = "Book Title and Author are required fields"
    
    static let warningTitleMessage: String = "Warning"
    static let areYouDoneTextBody: String = "Any information you entered will not be saved. Are you sure you want to exit?"
    static let yesString: String = "Yes"
    static let noString: String = "No"
}


class errorChecking {
    

    // MARK: Class Methods
    
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




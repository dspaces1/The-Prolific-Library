//
//  Library.swift
//  The-Prolific-Library
//
//  Created by Diego Urquiza on 9/9/15.
//  Copyright © 2015 Diego Urquiza. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Library {
    
    
    func getAllBooks() {
        
    }
    
    func deleteAllBooks() {
        
    }
    
    func getBookWithUrl() {
        
    }
    
    func deleteBookWithURL() {
        
    }
    
}

class Book: Library {
    
    // MARK: - Instance Properties
    
    var jsonBookData:JSON!
    
    
    init(bookInformationJSON:JSON ) {
        jsonBookData = bookInformationJSON
    }
    

    func addBookToLibrary() {
        
    }
    
    func editBookFromLibrary() {
        
    }
}
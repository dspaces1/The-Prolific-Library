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

typealias RestfulSuccessCallBack = (Bool) -> Void
typealias RestfulAllBooksCallBack = (Bool,[Book]) -> Void

class Library {
    
    // MARK: - Instance Properties
    
    private let serverLibraryUrl: String = "https://prolific-interview.herokuapp.com/55eef7425c65c90009e68721"
    private let serverAllBooks: String = "/books"
    private let serverBook: String = "/books/"
    private let serverClearAllBooks: String = "/clean"
    
    // MARK: - Instance Methods
    
    func getAllBooks(completionBlock: RestfulAllBooksCallBack) {
        
        Alamofire.request(.GET, serverLibraryUrl+serverAllBooks).response{
            request, response, data, error in
            
            if error == nil {
    
                let allBooks = self.convertJSONArrayToBookArray(JSON(data: data!))
  
                completionBlock(true,allBooks)
            } else {
                completionBlock(false,[])
            }

        }
    }
    
    private func convertJSONArrayToBookArray(json: JSON) -> [Book] {
        
        var bookArray: [Book] = []
        
        for (_,subJson):(String, JSON) in json {
            bookArray.append(Book(bookInformationJSON: subJson))
        }
        return bookArray
    }
    
    func deleteAllBooks(completionBlock: RestfulSuccessCallBack) {
        
        Alamofire.request(.DELETE, serverLibraryUrl+serverClearAllBooks).response{
            request, response, data, error in
            
            if error == nil {
                completionBlock(true)
            }else {
                completionBlock(false)
            }
        }
    }
    
    func deleteBookWithURL(selectedBookUrl: String,completionBlock: RestfulSuccessCallBack) {
        
        Alamofire.request(.DELETE, serverLibraryUrl+selectedBookUrl).response{
            request, response, data, error in
            
            if error == nil {
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    
}

class Book: Library {
    
    // MARK: - Instance Properties
    
    var jsonBookData:JSON!
    var jsonDictionary = [String:String]() {
        didSet{
            bookName = jsonDictionary["title"] ?? ""
            authorName = jsonDictionary["author"] ?? ""
            categoryNames = jsonDictionary["categories"] ?? ""
            publisherName = jsonDictionary["publisher"] ?? ""
            checkoutPersonsName = jsonDictionary["lastCheckedOutBy"] ?? ""
            checkoutTime = jsonDictionary["lastCheckedOut"] ?? ""
            bookUrl = jsonDictionary["url"] ?? ""
            
        }
    }
    private var checkoutParameter = [String:String]()
    
    var bookName: String!
    var authorName: String!
    var categoryNames: String!
    var publisherName: String!
    var checkoutPersonsName: String!
    var checkoutTime: String!
    var bookUrl: String!
    
    // MARK: - Instance Methods
    
    init(bookInformationJSON:JSON ) {
        jsonBookData = bookInformationJSON
        super.init()
        convertJSONtoDictionary(jsonBookData)
    }
    
    init(bookTitle: String, authorName: String, publisher: String, categories: String) {
        
        jsonBookData = [
            "author" : authorName,
            "categories" : categories,
            "title" : bookTitle,
            "publisher" : publisher]
        super.init()
        convertJSONtoDictionary(jsonBookData)
    }
    
    func convertJSONtoDictionary(json: JSON) {
        
        for (key, object) in json {
            jsonDictionary[String(key)] = object.stringValue
        }
    }

    
    func addBookToLibrary(completionBlock: RestfulSuccessCallBack) {
        Alamofire.request(.POST, serverLibraryUrl+serverBook, parameters: jsonDictionary, encoding: .JSON).response{
            request, response, data, error in
            
            if error == nil {
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    
    func editBookFromLibrary(bookUrl: String, completionBlock: RestfulSuccessCallBack) {
        Alamofire.request(.PUT, serverLibraryUrl+bookUrl, parameters: jsonDictionary, encoding: .JSON).response {
            request, response, data, error in
            
            if error == nil {
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
        
    }
    
    
    func checkoutBook(username: String, completionBlock: RestfulSuccessCallBack) {
        checkoutParameter = ["lastCheckedOutBy" : username]
        
        Alamofire.request(.PUT, serverLibraryUrl+bookUrl, parameters: checkoutParameter, encoding: .JSON).response {
            request, response, data, error in
            
            if error == nil {
                completionBlock(true)
            } else {
                completionBlock(false)
            }
            
        }
        
    }
    
    /// Format the date string
    func formatDateFromServer() -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date:NSDate = dateFormatter.dateFromString(checkoutTime)!
        
        let newDateForm = NSDateFormatter()
        newDateForm.dateFormat = "MMMM d, yyy h:mma"
        
        return newDateForm.stringFromDate(date)
    }
    
}
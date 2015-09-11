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
    
    private let serverLibraryUrl: String = "https://prolific-interview.herokuapp.com/55eef7425c65c90009e68721"
    private let serverAllBooks: String = "/books"
    private let serverBook: String = "/books/"
    private let serverClearAllBooks: String = "/clean"
    
    
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
    
    func getBookWithUrl() {
        
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
    var jsonDictionary = [String:String]()
    
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
    
    func editBookFromLibrary() {
        
    }
}
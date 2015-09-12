//
//  AddBookViewController.swift
//  The-Prolific-Library
//
//  Created by Diego Urquiza on 9/9/15.
//  Copyright © 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController {

    // MARK: - Instance Properties
    
    @IBOutlet weak var bookTitleTextField: UITextField!
    @IBOutlet weak var authorNameTextField: UITextField!
    @IBOutlet weak var publisherNameTextField: UITextField!
    @IBOutlet weak var categoriesTextField: UITextField!
    

    enum controllerMode {
        case addBook
        case editBook
    }
    var bookToEditData:Book?
    var bookToEditUrl:String?
    var currentRequest:controllerMode = .addBook
    
    
    // MARK: - Instance Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let book = bookToEditData {
            updateTextFields(book)
        }
    }
    
    /// Update textfields if in editBook mode
    func updateTextFields(book:Book) {
        bookTitleTextField.text = book.jsonDictionary["title"]
        authorNameTextField.text = book.jsonDictionary["author"]
        publisherNameTextField.text = book.jsonDictionary["publisher"]
        categoriesTextField.text = book.jsonDictionary["categories"]
    }
    
    // MARK: Done Bar Button logic
    
    ///If all textfields are empty dismiss ViewController. Otherwise warn the user
    @IBAction func checkIfUserIsDone(sender: AnyObject) {
        
        if areAllTextFieldsEmpty() {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            displayDoneAlert()
        }
        
    }
    
    ///Checks if all textfields are empty
    func areAllTextFieldsEmpty() -> Bool {
        
        if errorHandlingHelper.isStringEmpty(bookTitleTextField.text) && errorHandlingHelper.isStringEmpty(authorNameTextField.text) && errorHandlingHelper.isStringEmpty(publisherNameTextField.text) && errorHandlingHelper.isStringEmpty(categoriesTextField.text){
            return true
        } else {
            return false
        }
    }
    
    ///Display a warning alert and dismiss ViewController if the user accepts warning message
    func displayDoneAlert() {
        
        let alertView = UIAlertController(title: alertMessage.warningTitleMessage, message: alertMessage.areYouDoneTextBody, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: alertMessage.yesString, style: UIAlertActionStyle.Default, handler: { (_) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
        }))
        alertView.addAction(UIAlertAction(title: alertMessage.noString, style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alertView, animated: true, completion: nil)
    }

    
    // MARK: Sumbit Book Info logic
    
    /// Send Book data to server if required fields are filled
    @IBAction func submitBookInfo(sender: AnyObject) {
        
        if isBookTitleOrAuthorFieldEmtpy() {
            displayMissingFieldsAlert()
        } else {
            sendBookInformationToServer()
        }
    }
    
    /// Check required fields
    func isBookTitleOrAuthorFieldEmtpy() -> Bool {
        
        if errorHandlingHelper.isStringEmpty(bookTitleTextField.text) || errorHandlingHelper.isStringEmpty(authorNameTextField.text) {
            return true
        } else {
            return false
        }
    }
    
    /// Display alert if any required fields are missing
    func displayMissingFieldsAlert() {
        
        let alertView = UIAlertController(title: alertMessage.warningTitleMessage, message: alertMessage.missingBookOrAuthorFieldsMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: alertMessage.ok, style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    /// Grabs all fields and converts them into JSON. Then, disable User UI and renables with a progress indicator
    func sendBookInformationToServer() {
        
        let newBook = Book(bookTitle: bookTitleTextField.text!, authorName: authorNameTextField.text!, publisher: publisherNameTextField.text!, categories: categoriesTextField.text!)
        
        ProgressHelper.startLoadAnimationAndDisableUI(self)
        
        switch currentRequest {
            
        case .addBook:
            makePostRequestWithBook(newBook)
            
        case .editBook:
            makePutRequestWithBook(newBook)

        }
    }
    
    /// Check for non nil error from server request
    func wasServerCallSuccessful(isSuccessfulRequest: Bool) {
        
        if isSuccessfulRequest {
            self.displaySuccessPOSTAlert()
        }else {
            errorHandlingHelper.couldNotConnectToServerAlert(self, titleMessage: alertMessage.errorTitle, bodyMessage: alertMessage.couldNotConnectToServerMessage)
        }
    }
    
    /// Takes JSON data and submits a POST request.
    func makePostRequestWithBook(newBook: Book) {
        
        newBook.addBookToLibrary { (success) -> Void in
            self.wasServerCallSuccessful(success)
            ProgressHelper.reEnableUI(self)
        }
    }
    
    
    
    /// Displays alert if POST request was successful
    func displaySuccessPOSTAlert() {
        
        let alertView = UIAlertController(title: alertMessage.successTitle, message: customSuccessMessageBody(), preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: alertMessage.ok, style: UIAlertActionStyle.Default, handler: { (_) -> Void in
   
            switch self.currentRequest {
                
            case .addBook:
                self.dismissViewControllerAnimated(true, completion: nil)
                
            case .editBook:
                self.navigationController?.popToRootViewControllerAnimated(true)
                
            }
            
        }))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    /// update book with new information
    func makePutRequestWithBook(newBook: Book) {
        
        if let bookUrl = bookToEditUrl {

            newBook.editBookFromLibrary(bookUrl, completionBlock: { (success) -> Void in
                self.wasServerCallSuccessful(success)
                ProgressHelper.reEnableUI(self)
            })
        } else {
            errorHandlingHelper.generalErrorAlert(self)
        }
    }
    
    ///Custom Message with book name for Success Alert
    func customSuccessMessageBody() -> String {
        return "'\(bookTitleTextField.text!)' has been added/updated to the Prolific Library."
    }
    

}

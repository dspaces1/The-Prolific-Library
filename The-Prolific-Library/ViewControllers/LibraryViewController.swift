//
//  LibraryViewController.swift
//  The-Prolific-Library
//
//  Created by Diego Urquiza on 9/9/15.
//  Copyright © 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController {

    
    // MARK: - Instance Properties
    
    @IBOutlet weak var libraryTableView: UITableView!
    
    
    let library: Library = Library()
    var libraryBooks: [Book] = [] {
        didSet{
            libraryTableView.reloadData()
        }
    }
    
    
    
    // MARK: - Instance Methods
    
    
    /// Presents AddBookViewController
    @IBAction func displayAddNewBookView(sender: AnyObject) {
        
        let addBookViewController:AddBookViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AddBook") as! AddBookViewController
        
        presentViewController(addBookViewController, animated: true, completion: nil)
        
    }
    
    // MARK: Delete Entire Library Logic
    
    /// Present alert
    @IBAction func deleteEntireLibrary(sender: AnyObject) {
        displayAreYouSureAlert()
    }
    
    /// Display alert that will warn user about deleting library
    func displayAreYouSureAlert() {
        
        let alertView = UIAlertController(title: alertMessage.warningTitleMessage, message: alertMessage.deleteEntireLibraryWarning, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: alertMessage.yesString, style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            self.disableUIandDeleteLibrary()
        }))
        alertView.addAction(UIAlertAction(title: alertMessage.noString, style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    /// Delete entire library from server
    func disableUIandDeleteLibrary() {
        
        ProgressHelper.startLoadAnimationAndDisableUI(self)
        
        library.deleteAllBooks { (success) -> Void in
            if success {
                self.displaySuccessFullyDeleteLibrary()
                self.libraryBooks = []
            }else{
                errorHandlingHelper.couldNotConnectToServerAlert(self, titleMessage: alertMessage.errorTitle, bodyMessage: alertMessage.couldNotConnectToServerMessage)
            }
            ProgressHelper.reEnableUI(self)
        }
        
    }
    
    /// Display successfully deleted library Message
    func displaySuccessFullyDeleteLibrary() {
        let alertView = UIAlertController(title: alertMessage.successTitle, message: alertMessage.deletedEntireLibraryMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: alertMessage.ok, style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    
    
    // MARK: Get Library From Sever Logic
    
    /// Get entire library from server
    func disableUIandGetEntireLibrary() {
        
        ProgressHelper.startLoadAnimationAndDisableUI(self)
        
        library.getAllBooks { (success, books) -> Void in
            
            if success {
                self.libraryBooks = books
            } else {
                errorHandlingHelper.couldNotConnectToServerAlert(self, titleMessage: alertMessage.errorTitle, bodyMessage: alertMessage.couldNotConnectToServerMessage)
            }
            ProgressHelper.reEnableUI(self)
        }
        
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        disableUIandGetEntireLibrary()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetUp()
    }
    
    func viewSetUp() {
        libraryTableView.delegate = self
        libraryTableView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDataSource 


extension LibraryViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return libraryBooks.count ?? 0
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:LibraryTableViewCell = tableView.dequeueReusableCellWithIdentifier("BookCell") as! LibraryTableViewCell
        
        print(libraryBooks[indexPath.row].jsonDictionary)
        cell.book = libraryBooks[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension LibraryViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let bookUrl: String = libraryBooks[indexPath.row].jsonDictionary["url"]!
            
            ProgressHelper.startLoadAnimationAndDisableUI(self)
            library.deleteBookWithURL(bookUrl, completionBlock: { (success) -> Void in
                if success {
                    self.libraryBooks.removeAtIndex(indexPath.row)
                } else {
                    
                }
                ProgressHelper.reEnableUI(self)
            })
            
        }
    }
    
}

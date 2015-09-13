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
    var bookToSegue:Book!
    var refreshControl:UIRefreshControl!
    
    
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
        
        ProgressHelper.enableUI(false, currentView: self)
        
        library.deleteAllBooks { (success) -> Void in
            if success {
                self.displaySuccessFullyDeleteLibrary()
                self.libraryBooks = []
            }else{
                errorHandlingHelper.couldNotConnectToServerAlert(self, titleMessage: alertMessage.errorTitle, bodyMessage: alertMessage.couldNotConnectToServerMessage)
            }
            ProgressHelper.enableUI(true, currentView: self)
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
        
        ProgressHelper.enableUI(false, currentView: self)
        
        library.getAllBooks { (success, books) -> Void in
            
            if success {
                self.libraryBooks = books
            } else {
                errorHandlingHelper.couldNotConnectToServerAlert(self, titleMessage: alertMessage.errorTitle, bodyMessage: alertMessage.couldNotConnectToServerMessage)
            }
            ProgressHelper.enableUI(true, currentView: self)
            self.refreshControl.endRefreshing()
        }
        
    }
    
    // MARK: View Setup Logic
    
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
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        libraryTableView.addSubview(refreshControl)
    }
    
    func refresh() {
        disableUIandGetEntireLibrary()
    }
    

    
    // MARK: Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "ShowBook" {
            
            let detailBookView: BookDetailsViewController = segue.destinationViewController as! BookDetailsViewController
            detailBookView.book = bookToSegue
        }
        
    }


}

// MARK: - UITableViewDataSource 


extension LibraryViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return libraryBooks.count ?? 0
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:LibraryTableViewCell = tableView.dequeueReusableCellWithIdentifier("BookCell") as! LibraryTableViewCell

        cell.book = libraryBooks[indexPath.row]
        
        return cell
    }
}


// MARK: - UITableViewDelegate

extension LibraryViewController: UITableViewDelegate {
    
    
    // MARK: Delete Book Logic
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let bookUrl: String = libraryBooks[indexPath.row].bookUrl
            
            // Delete Selected Book
            ProgressHelper.enableUI(false, currentView: self)
            library.deleteBookWithURL(bookUrl, completionBlock: { (success) -> Void in
                if success {
                    self.libraryBooks.removeAtIndex(indexPath.row)
                } else {
                    errorHandlingHelper.couldNotConnectToServerAlert(self, titleMessage: alertMessage.errorTitle, bodyMessage: alertMessage.couldNotConnectToServerMessage)
                }
                ProgressHelper.enableUI(true, currentView: self)
            })
            
        }
    }
    
    
    // MARK: Segue Book Data Logic 
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let bookData = libraryBooks[indexPath.row]
        bookToSegue = bookData
        performSegueWithIdentifier("ShowBook", sender: nil)
    }
    
}

//
//  BookDetailsViewController.swift
//  The-Prolific-Library
//
//  Created by Diego Urquiza on 9/11/15.
//  Copyright © 2015 Diego Urquiza. All rights reserved.
//

import UIKit

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
    }
    
    
    // MARK: Edit Current Book Logic
    
    @IBAction func editCurrentBookInformation(sender: AnyObject) {
    }
    
    
    // MARK: Share Book via FB and Twitter
    
    @IBAction func shareLink(sender: AnyObject) {
    }
    
    
    // MARK: View Setup Logic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLabels()
    }

    func setUpLabels () {
        titleLabel.text = book.jsonDictionary["title"]
        authorLabel.text = book.jsonDictionary["author"]
        publisherLabel.text = "Publisher: " + book.jsonDictionary["publisher"]!
        categoryLabel.text =  "Tags: " + book.jsonDictionary["categories"]!
        
        if wasBookEverCheckedOut() {
            checkedOutLabel.text = "Last Checked Out: " + book.jsonDictionary["lastCheckedOutBy"]! + "@" + book.jsonDictionary["lastCheckedOut"]!
        } else {
            checkedOutLabel.text = "Last Checked Out: Has not been checked out."
        }
        
        
    }
    
    func wasBookEverCheckedOut() -> Bool {
        
        if errorHandlingHelper.isStringEmpty(book.jsonDictionary["lastCheckedOutBy"]) && errorHandlingHelper.isStringEmpty(book.jsonDictionary["lastCheckedOut"]) {
            
            return false
        } else {
            return true
        }
    }
    

}

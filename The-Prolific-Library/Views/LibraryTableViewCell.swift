//
//  LibraryTableViewCell.swift
//  The-Prolific-Library
//
//  Created by Diego Urquiza on 9/11/15.
//  Copyright © 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class LibraryTableViewCell: UITableViewCell {

    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthorTitle: UILabel!
    
    
    var book: Book? {
        didSet {
            if let book = book {
                self.bookTitle.text = book.jsonDictionary["title"]
                self.bookAuthorTitle.text = book.jsonDictionary["author"]
            }
        }
    }

}

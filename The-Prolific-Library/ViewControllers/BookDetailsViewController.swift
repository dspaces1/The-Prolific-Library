//
//  BookDetailsViewController.swift
//  The-Prolific-Library
//
//  Created by Diego Urquiza on 9/11/15.
//  Copyright © 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class BookDetailsViewController: UIViewController {

    
    // MARK: Instance Properties 
    
    var book:Book!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(book.jsonDictionary)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

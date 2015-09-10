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
    
    let library: Library = Library()
    
    // MARK: - Instance Methods
    
    @IBAction func displayAddNewBookView(sender: AnyObject) {
        
        let addBookViewController:AddBookViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AddBook") as! AddBookViewController
        
        presentViewController(addBookViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func deleteEntireLibrary(sender: AnyObject) {
        displayAreYouSureAlert()
    }
    
    func displayAreYouSureAlert() {
        
        let alertView = UIAlertController(title: alertMessage.warningTitleMessage, message: alertMessage.deleteEntireLibraryWarning, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: alertMessage.yesString, style: UIAlertActionStyle.Default, handler: { (_) -> Void in
            self.disableUIandDeleteLibrary()
        }))
        alertView.addAction(UIAlertAction(title: alertMessage.noString, style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    func disableUIandDeleteLibrary() {
        
        ProgressHelper.startLoadAnimationAndDisableUI(self)
        
        library.deleteAllBooks { (success) -> Void in
            if success {
                print("Worked")
            }else{
                print("Did not work")
            }
        }
        
        ProgressHelper.reEnableUI(self)
    }
    
    
    func disableUIandGetEntireLibrary() {
        
        ProgressHelper.startLoadAnimationAndDisableUI(self)
        
        library.getAllBooks { (success, books) -> Void in
            
            if success {
                print("success")
                print(books.count)
            } else {
                print("failed")
            }
        }
        
        ProgressHelper.reEnableUI(self)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        disableUIandGetEntireLibrary()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

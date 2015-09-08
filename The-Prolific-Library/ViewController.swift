//
//  ViewController.swift
//  The-Prolific-Library
//
//  Created by Diego Urquiza on 9/8/15.
//  Copyright © 2015 Diego Urquiza. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Example Get Request
        
        Alamofire.request(.GET, "https://prolific-interview.herokuapp.com/55eef7425c65c90009e68721/books/").response{
            request, response, data, error in
            print(request)
            print(response)
            let json = JSON(data: data!)
            print(json)
            //print(data)
            print(error)
        }
        
        
        
        
        //Example POST Request
        
//        let paramter = [
//            "author": "Ash Maurya",
//            "categories": "process",
//            "title": "Running Lean",
//            "publisher": "O'REILLY"
//        ]
        
//        Alamofire.request(.POST, "https://prolific-interview.herokuapp.com/55eef7425c65c90009e68721/books/", parameters: paramter, encoding: .JSON).response{
//                        request, response, data, error in
//                        print(request)
//                        print(response)
//                        print(data)
//                        print(error)
//        }
        
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

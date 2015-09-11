//
//  ProgressIndicatorHelper.swift
//  The-Prolific-Library
//
//  Created by Diego Urquiza on 9/10/15.
//  Copyright © 2015 Diego Urquiza. All rights reserved.
//

//import Foundation
import MBProgressHUD

class ProgressHelper {
    
    ///Disable current view and navigation view ui interactions. Starts loading animation.
    static func startLoadAnimationAndDisableUI (currentView:UIViewController) {
        
        currentView.view.userInteractionEnabled = false
        
        if let navigationBar = currentView.navigationController {
            navigationBar.view.userInteractionEnabled = false
        }
        let loadingNotification = MBProgressHUD.showHUDAddedTo(currentView.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        
    }
    
    ///Enable current view and navigation view ui interactions. Stops loading animation.
    static func reEnableUI(currentView:UIViewController) {
        
        MBProgressHUD.hideAllHUDsForView(currentView.view, animated: true)
        
        currentView.view.userInteractionEnabled = true
        
        if let navigationBar = currentView.navigationController {
            navigationBar.view.userInteractionEnabled = true
        }
    }
    
}
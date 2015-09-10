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
    
    static func startLoadAnimationAndDisableUI (currentView:UIViewController) {
        
        currentView.view.userInteractionEnabled = false
        
        if let navigationBar = currentView.navigationController {
            navigationBar.view.userInteractionEnabled = false
        }
        let loadingNotification = MBProgressHUD.showHUDAddedTo(currentView.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        
    }
    
    static func reEnableUI(currentView:UIViewController) {
        
        MBProgressHUD.hideAllHUDsForView(currentView.view, animated: true)
        
        currentView.view.userInteractionEnabled = true
        
        if let navigationBar = currentView.navigationController {
            navigationBar.view.userInteractionEnabled = true
        }
    }
    
}
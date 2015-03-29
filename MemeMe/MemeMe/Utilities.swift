//
//  Utilities.swift
//  MemeMe
//
//  Created by JeffreyLee on 3/28/15.
//  Copyright (c) 2015 Jeffrey. All rights reserved.
//

import Foundation
import UIKit;

public class Utilities {

/// Jeffrey
//  3/26/2015
////I put some common utility func here so every viewcontroller can use
//
//     
    
    var  isLandscapeOrientation : Bool {
        get {
          return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
        }
    }

  
    func toggleDeviceOrientation(){
        if( isLandscapeOrientation) {
            let value = UIInterfaceOrientation.Portrait.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
        } else {
            let value = UIInterfaceOrientation.LandscapeRight.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
        }
    }
    
    // MARK
    // get device keyboard height to shift up for bottom text field
    func getkeyboardHeight(notification:  NSNotification) ->CGFloat{
        
        let userinfo=notification.userInfo
        let keyboardSize = userinfo![UIKeyboardFrameEndUserInfoKey] as NSValue
        //add padding since text is not really at top or bottom
        return keyboardSize.CGRectValue().height - 15.00
    }
    
    func AutoSizeTextField(textField: UITextField, minFontsize: CGFloat) {
       //set upper case
        textField.text =  textField.text.uppercaseString
        textField.backgroundColor = UIColor.clearColor()
        //auto shrink to fit textfield
        textField.minimumFontSize = minFontsize
        textField.adjustsFontSizeToFitWidth = true
        textField.setNeedsLayout()
        textField.layoutIfNeeded()
    }
    
    func AutoSizeLabelField(lblField: UILabel, minScaleFactor : CGFloat) {
        //auto shrink to fit textfield
        lblField.minimumScaleFactor = minScaleFactor
        lblField.adjustsFontSizeToFitWidth = true
        lblField.setNeedsLayout()
        lblField.layoutIfNeeded()
    }
    
    //generic alert
    func showAlert( who : UIViewController, title: String, message : String){
        let myAlert = UIAlertController()
        myAlert.title = title
        myAlert.message = message
        
        let myaction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            who.dismissViewControllerAnimated(true, completion: nil)
        })
        myAlert.addAction(myaction)
        who.presentViewController(myAlert, animated:true , completion:nil)
    }
    
    init(){
    
    }
}
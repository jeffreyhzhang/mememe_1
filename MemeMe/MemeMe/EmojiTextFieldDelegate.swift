 
//
//  EmojiTextFieldDelegate.swift
//  MemeMe
//
// A little fun here using what we learned already about textfield delegate cllback
//
// Inititally I try to rotate to landscape when input text and rotate back to portrait.
// but I decided not to in the end.
//
// Modified by Jeffrey but most taken from Udacity class
//  Created by Jason on 11/11/14.
//  Copyright (c) 2014 Udacity. All rights reserved.
//

import Foundation
import UIKit

class EmojiTextFieldDelegate : NSObject, UITextFieldDelegate {
    var myDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let translations = [String : String]()
    
    override init() {
        super.init()
        
        translations["happy"] = "\u{1F604}"
        translations["money"] = "\u{24}"
        translations["usa"] = "\u{1F1FA}\u{1F1F8}"
        translations["love"] = "\u{0001F496}"
        translations["fish"] = "\u{E522}"
        translations["bird"] = "\u{E523}"
        translations["frog"] = "\u{E531}"
        translations["bear"] = "\u{E527}"
        translations["dog"] = "\u{E052}"
        translations["cat"] = "\u{E04F}"
    }
    
    // return to hide keyboard
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        
       // myDelegate.toggleDeviceOrientation(0)

        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var replacedAnEmoji = false
        var emojiStringRange: NSRange
        
        // Construct the text that will be in the field if this change is accepted
        var newText = textField.text as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        
        // For each dictionary entry in translations, pull out a string to search for
        // and an emoji to replace it with
        
        for (emojiString, emoji) in translations {
            
            // Search for all occurances of key (ie. "dog"), and replace with emoji (ie. 🐶)
            do {
                emojiStringRange = newText.rangeOfString(emojiString, options: NSStringCompareOptions.CaseInsensitiveSearch)
                
                // found one
                if emojiStringRange.location != NSNotFound {
                    newText = newText.stringByReplacingCharactersInRange(emojiStringRange, withString: emoji)
                    replacedAnEmoji = true
                }
                
            } while emojiStringRange.location != NSNotFound
        }
        
        // If we have replaced an emoji, then we directly edit the text field
        // Otherwise we allow the proposed edit.
        if replacedAnEmoji {
            textField.text = newText
            return false
        } else {
            return true
        }
    }
    
    func textFieldShouldBeginEditing(textField :UITextField)->Bool {
        textField.backgroundColor =  UIColor.brownColor()
        return true
    }

    
    // clear text before editing
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
        //myDelegate.toggleDeviceOrientation(1)
    }
    
    //all uppercase
    func textFieldDidEndEditing(textField: UITextField) {
        myDelegate.utils.AutoSizeTextField(textField, minFontsize: 8.0)
    }
    
}

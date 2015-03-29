//
//  MemeDetailVC.swift
//  MemeMe
//
//  This is the detailview of meme.
//  (1) Edit at the navigationbar as the rightbutton to allow edit selected meme
//      i.e. need go back to EditorVC if for editing,
//
//  (2)  "Trash" button is added to the toolbat to allow delet meme selected
//         After deleting, go back to sentmemes if still nat memes
//         otherwise goback to EditorVC to allow add new meme
//
//  Created by JeffreyLee on 3/19/15.
//  Copyright (c) 2015 Jeffrey. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailVC: UIViewController {
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var toolbarLX: NSLayoutConstraint!
    @IBOutlet weak var toolbarRX: NSLayoutConstraint!
    @IBOutlet weak var toolbarY: NSLayoutConstraint!
    
    var meme: Meme!
    var imgvwr :UIImageView!
    var mySize :CGRect!
    let myDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let isLandscpe = false ; //myDelegate.isLandscapeOrientation()
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        imgvwr = UIImageView()
        self.view.addSubview(imgvwr)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        toolbarLX.constant = -16.0
        toolbarRX.constant = -16.0
        toolbarY.constant = 0.0
        
        // add Edit to nav bar
        let edit =  UIBarButtonItem(title: NSLocalizedString("Edit", comment: ""), style: .Plain, target: self, action: "EditMeme")
        self.navigationItem.rightBarButtonItem = edit
        
        //add btns to toolbat
        let btn1 =  UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.Trash, target: self, action: "DeleteMeme")
        let btn2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolbar.items?.append(btn2)
        toolbar.items?.append(btn1)

        self.navigationController?.navigationBar.hidden = false
    }
    
    // MARK: viewDidLayoutSubviews
    // make the image fill the viewport
    // Depedning on the orientation, need to set the viewport properly.
    override func viewDidLayoutSubviews() {
        var img = meme.memeimg
        imgvwr.image = img
 
        let viewBounds : CGRect = self.view.bounds
        let topbarOffset  = self.topLayoutGuide.length
        let navbarHeight = self.navigationController?.navigationBar.frame.height
        let tabbarheight = self.tabBarController?.view.frame.size.height
        let toolbarheight = toolbar.frame.size.height
        let scrWidth = UIScreen.mainScreen().bounds.width
        
        
        //if normal...portrait img viewed in portrait, landscape img viewed in landscape
        //we need worry only  portait and landscape and vice verse
        let maxWD = scrWidth
        var vwWD = CGRectGetWidth( self.view.bounds )
        let vwHT = CGRectGetHeight( self.view.bounds )  -   self.topLayoutGuide.length  - toolbarheight
      
        // ratio>1 for portait
        let ratio =  img.size.height / img.size.width
        

        if(isLandscpe) {
            // view portraint in landscape....make the height the deciding factor, so we see text
            // view landscape in portait......make the height the deciding factor, so we see text
            if(ratio > 1.0){
                vwWD =   vwHT / ratio
            }
        } else {
            if(ratio < 1.0 ) {
                vwWD =   vwHT / ratio
            }
        }

 
        let xoffset = 0.5 * ( CGRectGetWidth( self.view.bounds ) - vwWD )
        
        let maximgsize = CGRectMake(0.0, 0.0, vwWD, vwHT)
        
        // The bounds are relative to its own coordinate system (0,0).
        // The frame are relative to the superview it is contained within.
        
        imgvwr.frame = maximgsize
        imgvwr.frame .offset(dx: xoffset, dy: topbarOffset)
        imgvwr.bounds = maximgsize
        imgvwr.contentMode = UIViewContentMode.ScaleAspectFill
        imgvwr.autoresizingMask = UIViewAutoresizing.FlexibleWidth  //| UIViewAutoresizing.FlexibleHeight
        
    }
    
    // delete/trash meme
    func DeleteMeme(){
        //find meme from array and delete
        if let index = find(myDelegate.memes, meme){
            myDelegate.memes.removeAtIndex(index)
            
            //self.performSegueWithIdentifier("Back2AllAfterDelete", sender: self)
            // but the nav history stack is wrong....go back to details
 
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            var newVC = mainStoryboard.instantiateViewControllerWithIdentifier("DisplayMemes") as UITabBarController
            self.presentViewController(newVC, animated: true, completion: nil)
        }
    }
    
    // allow edit meme...pass the selected meme back to EditorVC
    func EditMeme(){
       // send back to home page with data
        //pass data to editorVC
        self.performSegueWithIdentifier("Detail2EditorMeme", sender: meme)
    }
    
    // There two cases: after deleting, go back to sentmemes if still nat memes
    //                  otherwise goback to EditorVC to allow add new meme
    //   If for editing, need go back to EditorVC
    override func prepareForSegue(segue: UIStoryboardSegue,  sender: AnyObject?){
        if(segue.identifier == "Detail2EditorMeme"){
            let editorVC: EditorVC = segue.destinationViewController as EditorVC
            editorVC.currentMeme = sender as?  Meme
            editorVC.isEditing = true
        } else if ( segue.identifier == "Back2AllAfterDelete"){
            var destController = segue.destinationViewController as UITabBarController
            destController.navigationController?.navigationBarHidden = false
        }
    }

    
}
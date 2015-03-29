//
//  EditorVC.swift
//  MemeMe
//
//
//  (1) I am having a little fun here...using Emoji text delegate for toptext to show usa/love/fish/dog etc
//      It will captialize all letters before return and shrink the font to fit the textfield via adjustsFontSizeToFitWidth
//      You can hit return or anywhere or cancel on the image to dismiss the keyboard.
//      I am limiting bottom text to 80 letters...only numbers after 60 chars....
//      I also change the background color to brown to bring some contrast and clear it when done.
//
//  (2) I create navigationbar, bottom toolbar  as well as top/bottom textfield and imageviewer in code. 
//       Since I am tired of positioning these in storyboard and using outlet to control later, so there is not much in storyboard.
//     
//  (3) The share meme on navigationbar is disabled until image is picked  to prevent share empty meme with no image.
//
//  (4) I created a customized tablecell and psotioning the toptext and bottomtext evenly on two lines
//
//  Lessons learned: 
//
//  self.topLayoutGuide.length is not avilable  in viewDidLoad or viewWillAppear.
//  I have to move code to viewWillLayoutSubviews to position properly.
//  But the bad news is that this is executed as many times as how many subviews...at least 3 time since we
//  have toptext, bottomtext and imageview. It seems not a good place to position these subviews.
//
//
//  Created by JeffreyLee on 3/19/15.
//  Copyright (c) 2015 Jeffrey. All rights reserved.
//

import UIKit
import AVFoundation

//persistent pic to album: writeImageToSavedPhotosAlbum
//import AssetsLibrary

class EditorVC: UIViewController, UIImagePickerControllerDelegate,UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var HomeNav: UINavigationItem!
    @IBOutlet weak var toolbarBY: NSLayoutConstraint!
    @IBOutlet weak var toolbarRX: NSLayoutConstraint!
    @IBOutlet weak var toolbarLX: NSLayoutConstraint!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var toptxt = UITextField()
    var btmtxt = UITextField()
    var pickedimg = UIImageView()
  
    var myDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var currentMeme: Meme? //when editing, this will be set

    var isEditing :Bool!
    var  navbarHeight : CGFloat!
    var  topbarOffset : CGFloat!
    var  toolbarheight : CGFloat!
    
    //shift keyboard for bottom textfield only
    var blnShiftKeyboard: Bool!
    let emoji = EmojiTextFieldDelegate()

    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.whiteColor(),  // black outline
        NSStrokeWidthAttributeName : CFloat(9.0),         // white
        NSForegroundColorAttributeName :  UIColor.blackColor(),
       // NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 18)! //Helvetica-Bold"
        //boldAttributes
        //boldSystemFontOfSize
        NSFontAttributeName: UIFont(descriptor: UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody).fontDescriptorWithSymbolicTraits(.TraitBold), size: 18)
    ]
    // position toptext, btmtext and imgviewer
    // execute many times (3 or 4 in this app) during the loading
    // since each subview will make a pass here...i.e. just a textfield toptext will cause this to be executed once
    //it seems to me it is better to resize the item only for that pass.
    // i.e. resize image when the subview is img, textfield when it is textfile etc.
    
    override func viewWillLayoutSubviews() {
   
        let viewBounds : CGRect = self.view.bounds
        topbarOffset  = self.topLayoutGuide.length
        navbarHeight = self.navigationController?.navigationBar.frame.height
        let tabbarheight = self.tabBarController?.view.frame.size.height
        let scrHight = UIScreen.mainScreen().bounds.height
        
        
        toolbarheight = toolbar.frame.size.height
        let scrWidth = UIScreen.mainScreen().bounds.width
        let maxWD = scrWidth
        
        ////no self.topLayoutGuide.length data until in view
        
        var vwWD = CGRectGetWidth( self.view.bounds )
        let vwHT = CGRectGetHeight( self.view.bounds )  -   self.topLayoutGuide.length  - toolbarheight
        
        // yGap is the height of textfield and gap from toplayoutguide to toptext field
        let xGap = CGFloat(0.0)
        let yGap = CGFloat(20.0)
        let xoffset = 0.5 * ( CGRectGetWidth( self.view.bounds ) - vwWD )

        let maximgsize = CGRectMake(0.0, 0.0, vwWD, vwHT)
        
        // The bounds are relative to its own coordinate system (0,0).
        // The frame are relative to the superview it is contained within.
        
        pickedimg.frame = maximgsize
        pickedimg.frame .offset(dx: xoffset, dy: topbarOffset)
        pickedimg.bounds = maximgsize
        pickedimg.contentMode = UIViewContentMode.ScaleAspectFill
        pickedimg.autoresizingMask =  UIViewAutoresizing.FlexibleWidth //| UIViewAutoresizing.FlexibleHeight
        
        //Always put text on put in viewport seems to be a bad idea.
        // since if you fit landscape image in portaint orientation screen
        // the text will be way above the image. So we need base the y axis of text on image location
        // so we always rorate to landscape!!!
        
        //this is the Y value for btmtext field ( 20 for gap and 20 for text height)
        let ybtmtxtGap  =  vwHT - yGap - 10
        
        toptxt.frame  = CGRectMake(0.0, 5.0, vwWD, yGap)
        btmtxt.frame = CGRectMake(0.0, ybtmtxtGap, vwWD, yGap)
        
        //move down from zero by statusbar  height and nav bar height
        toptxt.frame.offset(dx: xoffset, dy: topbarOffset)
        btmtxt.frame.offset(dx: xoffset, dy: topbarOffset)
        
        //reset toolbar location
        toolbarBY.constant = 0.0
        toolbarLX.constant = -16.0
        toolbarRX.constant = -16.0
  
        
        //set img background...z-order
        self.view.sendSubviewToBack(pickedimg);
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        //if landscaping, set to portrait
  /*
        if myDelegate.isLandscapeOrientation(){
            myDelegate.toggleDeviceOrientation(Int32(0))
        }
 */
        
        //temp holder...off screen
        var tmpframe  = CGRectMake(-200.0, -200.0, 100, 30)
        toptxt.frame = tmpframe
        btmtxt.frame = tmpframe
        pickedimg.frame = tmpframe
        toptxt.text = "TOP"
        btmtxt.text = "BOTTOM"
        btmtxt.defaultTextAttributes = memeTextAttributes
        toptxt.defaultTextAttributes = memeTextAttributes
        
        toptxt.textAlignment = NSTextAlignment.Center
        btmtxt.textAlignment = NSTextAlignment.Center

        
        self.view.addSubview(toptxt)
        self.view.addSubview(btmtxt)
        self.view.addSubview(pickedimg)
        self.view.sendSubviewToBack(pickedimg)

        //btmtext.keyboardType  =  UIKeyboardTypeDecimalPad;
        btmtxt.tag = 1
        toptxt.tag = 0
        
        // a little fun here: Love=>heart    USA==>flag etc
        btmtxt.delegate = self
        toptxt.delegate = emoji
        
        
        //set default/initial image, so no need to pick if you do not want to.
        //self.pickedimg.image = myDelegate.baseImg
        isEditing = false
        blnShiftKeyboard = false

        if let mysrc = currentMeme  {
            isEditing = true
            pickedimg.image = mysrc.image
            toptxt.text = mysrc.toptext
            btmtxt.text = mysrc.bottomtext
        }
        
        configNavigationBar()
        configToolbar()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //show nav bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.view.backgroundColor  = UIColor.blackColor()
        
        //get keyboard event
        subscribekeyboardNotifications()
        // still no data for self.topLayoutGuide.length
       // println(self.topLayoutGuide.length)
    
        if ( pickedimg.image != nil ){
        //enable when photo is picked
        //if(isEditing!){
            self.navigationItem.leftBarButtonItem?.enabled = true
        } else {
            self.navigationItem.leftBarButtonItem?.enabled = false
        }
    }
    
    
    //return in cap. string per requirement
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // Construct the text that will be in the field if this change is accepted
        var newText = textField.text as NSString
        
        //limit length to 50 for input
        if (newText.length > 80) {
            return false;
        }
        
        //limit only to numbers after 60 chars
        if (newText.length > 60) {
           
            let inverseSet = NSCharacterSet.decimalDigitCharacterSet().invertedSet
            // any not numbers will be ""
            let itms = string.componentsSeparatedByCharactersInSet(inverseSet)
            
            // Rejoin these
            let filtered = join("", itms)
            
            // If the original string is equal to the filtered string, i.e. if no
            // inverse characters were present to be eliminated, the input is valid
            // and the statement returns true; else it returns false
            return string == filtered
        }
        //all caiptal vs 1st letter Cap......uppercaseString vs capitalizedString
        return true;
    }
    
    //clear text if not editing meme
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
        textField.backgroundColor = UIColor.brownColor()
    }
    
    //reset background back to clearColor()
    //
    func textFieldDidEndEditing(textField: UITextField) {
        myDelegate.utils.AutoSizeTextField(textField, minFontsize: 8.0)
    }
    
    
    func textFieldShouldReturn( textField: UITextField) -> Bool {
 
        textField.resignFirstResponder()
        //alreays reset to false, in case user set text at btm first, then top txt...causing top txt shift up too
        blnShiftKeyboard = false

        //set to portaint orientation before return
        //myDelegate.toggleDeviceOrientation(0)
        
        return true
    }
    
    //I want the keyboard dismissed when user touches anything outside the keyboard like "Cancel"
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //this will do...anywhere in view
        self.view.endEditing(true)
    }
    
    // MARK
    // need know key will show event
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribekeyboardNotifications()
    }
    
    // MARK
    // shift keyboard up by keyboard height
    // so textfeld at bottom is not hidden behinde keyboard
    // as you type annotations to the image
    func keyboardWillShow(notification: NSNotification){
        //only for bottomtext
        if(blnShiftKeyboard!){
            self.view.frame.origin.y  -=  myDelegate.utils.getkeyboardHeight(notification)
        }
    }
    
    // MARK
    //this is like onfocus ....
    //shift keyboard only for bottom textfield to avoid keyboard covering textfield
    func textFieldShouldBeginEditing(textField :UITextField)->Bool {
        textField.backgroundColor =  UIColor.whiteColor()
        if(textField.tag == 1){
            blnShiftKeyboard = true
        }
        else {
            blnShiftKeyboard = false
        }
        //toggle to landscape for more room to text input
        //myDelegate.toggleDeviceOrientation(1)

        return true
    }
    
    func keyboardWillHide(notification: NSNotification){
        //only for bottomtext
        if(blnShiftKeyboard!){
            self.view.frame.origin.y  += myDelegate.utils.getkeyboardHeight(notification)
        }
    }
    
    // MARK
    // subscribe and unsubscribe the keyboard event
    // If you wanted the method to take the sender as a parameter, you would put a colon at the end:
    //
    func subscribekeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        //UIKeyboardWillHideNotification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribekeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func configNavigationBar(){
        let btn1 =  UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.Action, target: self, action: "ShareImage:")
        let btn2 =  UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .Plain, target: self, action: "ShareImage:")
        let btn3 =  UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .Plain, target: self, action: "CacnelToDismiss:")
        if(isEditing!){
            self.navigationItem.leftBarButtonItem = btn2
        } else {
            self.navigationItem.leftBarButtonItem = btn1
        }
        self.navigationItem.rightBarButtonItem = btn3
       // Navigation bars are only shown for view controllers in a navigation stack.
       // when you try to present this controller directly from code it will has no nav bar!!!
        
    }
    
    // MARK: configToolbar
    // progrmatically create toolbar 
    //
    func configToolbar(){
        //set toolbar position
        toolbarBY.constant = 0.0
        toolbarLX.constant = 0.0
        toolbarRX.constant = 0.0
        
        //add btns
        let btn1 =  UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.Camera, target: self, action: "PickImagefromCamera:")
        let btn2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let btn3 =  UIBarButtonItem(title: NSLocalizedString("Album", comment: ""), style: .Plain, target: self, action: "PickImgfromAlbum:")
        let btn4 =  UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        
        btn4.width = 30
        btn1.tag = 9  //specail so we can disable if no camera
        
        
        //disable camera if no device
        var noCamera = true
        let devices = AVCaptureDevice.devices()
        if  let dvs = devices {
            for device in devices {
                // Make sure this particular device supports video
                if (device.hasMediaType(AVMediaTypeVideo)) {
                    noCamera = false
                    break
                }
            }
        }
        if ( noCamera) {
            //disable camera btn:UIBarButtonItem  on toolbar
             btn1.enabled = false
        }
        
        
        toolbar.items?.append(btn2)
        toolbar.items?.append(btn1)
        toolbar.items?.append(btn4)
        toolbar.items?.append(btn3)
        toolbar.items?.append(btn2)

    }
    
    //delegate for imagepicker
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary!) {
        //keep the original aspect ratio of the image and center it within the UIImageView
        if let tempImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            pickedimg.contentMode = UIViewContentMode.ScaleAspectFit
            pickedimg.image  = tempImage
    
            //enable share once photo is selected
            self.navigationItem.leftBarButtonItem?.enabled = true
            //isEditing = true
            /*
            let ratio = tempImage.size.width / tempImage.size.height
            if(ratio > 1.0) {
                myDelegate.toggleDeviceOrientation(Int32(1))
                println("flip? to landscape?")
            }
            */
            //////fill the screen
            pickedimg.becomeFirstResponder()
            
        }
        picker.dismissViewControllerAnimated( true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        picker.dismissViewControllerAnimated( true, completion: nil)
    }
    
    func PickImgfromAlbum(sender: AnyObject) {
        let myctrl = UIImagePickerController()
        myctrl.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        myctrl.allowsEditing = true;
        myctrl.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        myctrl.delegate  = self
        self.presentViewController(myctrl, animated: true, completion:  nil)
    }
    
    
    func PickImagefromCamera(sender: AnyObject) {
        // if camera is available
        var noCamera = true
        let devices = AVCaptureDevice.devices()
        if  let dvs = devices {
            for device in devices {
                // Make sure this particular device supports video
                if (device.hasMediaType(AVMediaTypeVideo)) {
                    noCamera = false
                    break
                }
            }
        }
        
        if ( noCamera) {
            //disable camera btn:UIBarButtonItem  on toolbar
            for itm in toolbar.items!  {
                if let btn = itm as? UIBarButtonItem {
                    if(btn.tag == 9)
                    {
                        btn.enabled = false
                        break
                    }
                }
            }
            
            let myAlert = UIAlertController()
            myAlert.title = "No camera is available"
            myAlert.message = "Camera on toolbar will be disabled, pick a photo from album!"
            
            let myaction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                self.dismissViewControllerAnimated(true, completion: nil)
                ////should go back home when touch  OK
                self.PickImgfromAlbum(self)
            })
            
            myAlert.addAction(myaction)
            self.presentViewController(myAlert, animated:true , completion:nil)
            
        } else {
            let  picker = UIImagePickerController()
            picker.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
            picker.delegate = self;
            picker.allowsEditing = true;
            picker.sourceType = UIImagePickerControllerSourceType.Camera;
            
            self.presentViewController(picker, animated:true , completion:nil)
        }
    }
    // user taped Cancel....start over
    func CacnelToDismiss(sender: UIBarButtonItem) {
        //pop to top
        //clear all
        self.toptxt.text = "TOP"
        self.btmtxt.text = "BOTTOM"
        self.pickedimg.image = nil
        isEditing = false
        
        let controller = self.navigationController!.viewControllers[0] as UIViewController
        self.navigationController?.popToViewController(controller, animated: true)
        //self.view.layoutSubviews()
    }
    
    // MARK: ShareImage
    //
    // this is when user tap share at left top corner on nav bar
    // we save shared imgs to model for display history etc
    //
    func ShareImage(sender: UIBarButtonItem) {
        if(self.pickedimg.image == nil) {
            myDelegate.utils.showAlert(self, title: "No image selected yet", message: "Pick a photo from album first!")
            return
        }
        var image : UIImage = generatedMemeimg()
        // save to model if successful...otherwsie cannot share
        if (!self.saveMemeImg(image) ) {
                myDelegate.utils.showAlert(self, title: "No image selected yet", message: "Pick a photo from album first!")
        } else {
            let activityViewController = UIActivityViewController(
                activityItems: [image],
                applicationActivities: nil)
            //callback function when done
            activityViewController.completionWithItemsHandler = {
                (activityType, success, items, error) in
                
                if(!success) {
                   println(error)
                }
                //redirect to tableviewcontroller...UITabBarController
                let viewController:UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DisplayMemes") as UITabBarController
                self.presentViewController(viewController, animated: false, completion: nil)
                //this will cause right nav btn gone????
                //self.performSegueWithIdentifier("ShowAllMemes", sender: self)
            }
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
    
    // MARK
    // save the meme data
    func saveMemeImg(image :UIImage) -> Bool {
        if let img = pickedimg.image? {
           var meme = Meme(toptxt: toptxt.text!, btmtex: btmtxt.text!, img: pickedimg.image!, memeimage: image)
            myDelegate.memes.append(meme)
            return true
        }
        // no image picked yet and try to share?
        return false
    }
    
    func generatedMemeimg()-> UIImage {
        //hide toolbar otherwise it will be part of the image???
        toolbar.hidden = true
        self.navigationController?.navigationBar.hidden = true
        
        let wd = self.view.bounds.width
        let ht = self.view.bounds.height
        
        let mySize = CGSize(width: wd, height: ht)
        let myCapArea = CGRectMake(0.0, 0.0, wd, ht)
    
        UIGraphicsBeginImageContext(mySize)
        // this will have navbar etc in snapshot.
        self.view.drawViewHierarchyInRect(myCapArea, afterScreenUpdates: true)
        let myimg : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //crop the black topbar and btm toolbar to get a clean
        let mynewsize : CGRect =  CGRectMake( 0.0, topbarOffset, wd, ht - topbarOffset - toolbarheight)
         // Create bitmap image from context using the rect
        let imgref: CGImageRef = CGImageCreateWithImageInRect(myimg.CGImage, mynewsize)
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imgref, scale: myimg.scale, orientation: myimg.imageOrientation)!
        
        toolbar.hidden = false
        self.navigationController?.navigationBar.hidden = false
        return image
    }
    
    ////Auto rotate
    /*
    override func shouldAutorotate() -> Bool {
        return true
    }
 
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        println(" you rotated...collection reload")
    }
   */
}


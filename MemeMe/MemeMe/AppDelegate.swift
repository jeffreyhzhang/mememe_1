//
//  AppDelegate.swift
//  MemeMe
//
//  In order to debug/test change rootviewcontroller in code,
//  I load one image at app start and insert itto memes
//  If we have at least one memes, go to SentMemes history
//  Otherwise goto EditorVC to add new meme.
//
//  set debugRootVC = false before go live  or submit project
//
//  I have build a small library called utilites deals with alert, keyboard etc
//
//  Created by JeffreyLee on 3/19/15.
//  Copyright (c) 2015 Jeffrey. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var memes = [Meme]()
    var baseImg : UIImage!
    var debugRootVC = false   // debugging which rootVC to start depending on memes data
    let utils = Utilities()   // common utils
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
 
        ///clear all before add one to meme if persistent data
        //memes.removeAll(keepCapacity: false)
        if( debugRootVC ) {
            var fileURL = NSBundle.mainBundle().URLForResource("Jeff", withExtension: "JPG")
            let beginImage = CIImage(contentsOfURL: fileURL)
            let filter = CIFilter(name: "CISepiaTone")
            filter.setValue(beginImage, forKey: kCIInputImageKey)
            filter.setValue(0.5, forKey: kCIInputIntensityKey)
            baseImg = UIImage(CIImage: filter.outputImage)
            var mytest = Meme(toptxt: "Test", btmtex: "test btm", img: baseImg, memeimage: baseImg)
            memes.append(mytest)
        }
        // since the default rootViewController is  tabcontroller to shoe sentmemes
        // we want change it when there is no sentmemes yet
        if(memes.count == 0 ) {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            var newVC = mainStoryboard.instantiateViewControllerWithIdentifier("EditorVC") as EditorVC
            var navigationController : UINavigationController = UINavigationController(rootViewController: newVC)
            self.window?.rootViewController = nil;
            self.window?.rootViewController = navigationController;
            self.window?.makeKeyAndVisible();
        }
       
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
       //let defaults = NSUserDefaults.standardUserDefaults()
       //defaults.setObject(memes, forKey: "SavedMemeData")
    }
    
 
    // limit only portrit and UIInterfaceOrientationMask.LandscapeLeft
  
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow) -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue ) | Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue)
      }
}


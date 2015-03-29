//
//  CollectionVC.swift
//  MemeMe
//
//  Collection fro TabController
//  Ref: http://makeapppie.com/2014/09/15/swift-swift-programmatic-navigation-view-controllers-in-swift/
//
//  Created by JeffreyLee on 3/19/15.
//  Copyright (c) 2015 Jeffrey. All rights reserved.
//

import Foundation
import UIKit

class CollectionVC: UIViewController, UICollectionViewDataSource, UITableViewDelegate ,UICollectionViewDelegateFlowLayout {
    // get from app...global
    var allmemes :[Meme]!
    let appDelegate  = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewWillAppear(animated: Bool) {
        //add nav to  EditorVC to add new
        let btn =  UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.Add, target: self, action: "AddNew")
        self.navigationController?.navigationBar.hidden = false
        self.navigationItem.rightBarButtonItem = btn
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        allmemes = (UIApplication.sharedApplication().delegate as AppDelegate).memes
    }
    
    func AddNew(){
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var newVC = mainStoryboard.instantiateViewControllerWithIdentifier("EditorVC") as EditorVC
        
        //got extra tab bar at bottom
        self.hidesBottomBarWhenPushed = true;
        self.performSegueWithIdentifier("FromCollection", sender: self)
    }
    // MARK: Table View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allmemes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collCell", forIndexPath: indexPath) as ImgCellVC
        let itm = self.allmemes[indexPath.row]
        cell.imgvw.image =  itm.memeimg
        cell.imgvw.contentMode = UIViewContentMode.ScaleAspectFit
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC")! as MemeDetailVC
        detailController.meme = self.allmemes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)

    }
    //for section...layout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // always 75 x 75 ??...customized based on size??
        // let itm = self.allmemes[indexPath.row]
        // println(itm.image.size.width)
        return CGSize(width: 75.0, height: 75.0)
    }
    
    /*
    override func shouldAutorotate() -> Bool {
        return true
    }
    //when landscape you see 4 items, but in portraint you see only 3
    // one is way on the right....it is not updated
    // how to tell app it is rotated...but this is not called when I toggle.
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        //reload data
        // image.transform => CGAffineTransformIdentity??
        
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        println(" you rotated...collection reload")
    }
    */
}
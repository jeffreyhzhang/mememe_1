//
//  TableVC.swift
//  MemeMe
//
//  Ref:  http://www.raywenderlich.com/forums/viewtopic.php?f=2&t=18517
//
//  Customized tablecell seems need a little work about the  calculating height of the cell
//
//  Created by JeffreyLee on 3/19/15.
//  Copyright (c) 2015 Jeffrey. All rights reserved.
//

import Foundation
import UIKit

class TableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // get from app...global
    var allmemes :[Meme]!
    let appDelegate  = UIApplication.sharedApplication().delegate as AppDelegate
   
    
    override func viewWillAppear(animated: Bool) {
        //add nav to go to EditorVC
        let btn =  UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.Add, target: self, action: "AddNew")
        self.navigationItem.rightBarButtonItem = btn
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = false
     
        self.navigationItem.hidesBackButton = true
        //self.navigationController?.setToolbarHidden(false, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allmemes = (UIApplication.sharedApplication().delegate as AppDelegate).memes
        // go back to editor
        if(allmemes.count==0){
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            var newVC = mainStoryboard.instantiateViewControllerWithIdentifier("EditorVC") as EditorVC
            var navigationController : UINavigationController = UINavigationController(rootViewController: newVC)
         
            appDelegate.window?.rootViewController = navigationController;
            appDelegate.window?.makeKeyAndVisible();
        }
    }

    
    // MARK: navigate back home
    // why nav bar not showing if using EditorVC to show...
    // navbar is not in stack?
    func AddNew(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var newVC = mainStoryboard.instantiateViewControllerWithIdentifier("EditorVC") as EditorVC
        
        //grod off extra tab bar at bottom when go to editor
        self.hidesBottomBarWhenPushed = true;
        self.performSegueWithIdentifier("FromTable", sender: self)
        
        // no nav or status bar???
        //self.presentViewController(newVC, animated: true, completion: nil)
    }
    
    // MARK: Table View Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allmemes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let itm :Meme = self.allmemes[indexPath.row]
        /*
        // use default UITableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("tabCell") as  UITableViewCell
        cell.textLabel?.text = itm.toptext
        cell.detailTextLabel?.text = itm.bottomtext
        cell.imageView?.image = itm.memeimg
        appDelegate.utils.AutoSizeLabelField(cell.textLabel!, minScaleFactor: 0.3)
  
        */
        // customized tablcell not that great....need some work in the future
        let cell = tableView.dequeueReusableCellWithIdentifier("tabCell") as  TableCellVC
        cell.topLabel.text = itm.toptext
        cell.btmLabel.text = itm.bottomtext
        cell.img = itm.memeimg
        appDelegate.utils.AutoSizeLabelField(cell.topLabel, minScaleFactor: 0.3)
        appDelegate.utils.AutoSizeLabelField(cell.btmLabel, minScaleFactor: 0.3)
        
        return cell
    }
         
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC")! as MemeDetailVC
        detailController.meme = self.allmemes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    //delegate to get the dynamic height of cell of my customized tablecell
   
    func tableView( tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
    
            let cell = tableView.dequeueReusableCellWithIdentifier("tabCell") as TableCellVC
            // Get the actual height required for the cell
            var height  = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
            // Add an extra point to the height to account for the cell separator, which is added between the bottom
            //// of the cell's contentView and the bottom of the table view cell.
            height += 1.0
            return height < 75.0 ? 75.0 : height
    }

    
}

//
//  TableCellVC.swift
//  MemeMe
//
//  Try to use customized tablecell instead of the default.
//
//  Reference : http://ashfurrow.com/blog/you-probably-dont-understand-frames-and-bounds/
//
//
//  Created by JeffreyLee on 3/20/15.
//  Copyright (c) 2015 Jeffrey. All rights reserved.
//

import UIKit

class TableCellVC: UITableViewCell {

    var img : UIImage!
    var topLabel = UILabel()
    var btmLabel  = UILabel()
    var imgvwr = UIImageView()
    var myDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    //this is the min size for imageviewer
    //it can be bigger for biger device
    let minWidth = CGFloat(75.00)
    let minWHeight = CGFloat(75.00)
    let textHeight = CGFloat(20.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        topLabel.textColor = UIColor.blackColor()
        btmLabel.textColor = UIColor.blackColor()
        imgvwr.contentMode  =  UIViewContentMode.ScaleAspectFit
        //add to view
       self.addSubview(imgvwr)
       self.addSubview(topLabel)
       self.addSubview(btmLabel)
       //make img on bkfrnd not to block text
       self.sendSubviewToBack(imgvwr)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        //println(" setSelected ")
    }
    
    // this seems to be a bad place to put code here since it is execute many many times 
    // if a table has 10 rows, each cell has three items....30+  times !!!!
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let isLandscpe =  myDelegate.utils.isLandscapeOrientation
        
        // use up to 1/5 for the image...when in landscape, use height as base measure
        let newWidth =  isLandscpe ?   UIScreen.mainScreen().bounds.height / 5.0 : UIScreen.mainScreen().bounds.width / 5.0
        
        let wd = newWidth > minWidth ? newWidth : minWidth
        imgvwr.image = img
        imgvwr.frame = CGRectMake(0.0, 0.0, wd, wd)
        //if( img.size.height  > img.size.width )
        imgvwr.contentMode  =  UIViewContentMode.ScaleAspectFit
        
        // txt will be off by 10 from middle of img height
        let topptxtY = wd / 2.0 - 10.0 - textHeight
        let txtWD = isLandscpe ?  ( UIScreen.mainScreen().bounds.height * 0.8) : (UIScreen.mainScreen().bounds.width * 0.8)
        topLabel.frame = CGRectMake(wd,  topptxtY, txtWD, textHeight)
        topLabel.textAlignment = NSTextAlignment.Left
        
        let myY = wd  / 2.0 + 10.0
        btmLabel.frame = CGRectMake(wd, myY, txtWD, textHeight)
        btmLabel.textAlignment = NSTextAlignment.Left
    
        btmLabel.font =  UIFont(name: "HelveticaNeue-CondensedBlack", size: 10)!
        topLabel.font =  UIFont(name: "HelveticaNeue-CondensedBlack", size: 10)!
        
        myDelegate.utils.AutoSizeLabelField(topLabel, minScaleFactor: 0.3)
        myDelegate.utils.AutoSizeLabelField(btmLabel, minScaleFactor: 0.3)
        
        
     }
}

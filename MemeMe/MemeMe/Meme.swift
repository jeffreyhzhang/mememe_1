//
//  Meme.swift
//  MemeMe
//
//  This is the model(M) in MVC
//  Created by JeffreyLee on 3/19/15.
//  Copyright (c) 2015 Jeffrey. All rights reserved.
//

import Foundation
import UIKit

class Meme : NSObject {
    // image and toptext and bottm tex
    
    var toptext : String
    var bottomtext : String
    var image : UIImage
    var memeimg : UIImage
    
     init( toptxt : String, btmtex : String, img : UIImage,  memeimage : UIImage) {
        self.toptext = toptxt
        self.bottomtext = btmtex
        self.image = img
        self.memeimg = memeimage
    }
}

//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Gerard Heng on 15/5/15.
//  Copyright (c) 2015 gLabs. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var meme: Meme!
    var memeId: Int!
    
    
    @IBOutlet weak var detailImage: UIImageView!
    
    override func viewDidLoad() {
        
        self.detailImage.image = meme.memedImage
    }
    
    
}

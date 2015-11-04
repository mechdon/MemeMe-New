//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Gerard Heng on 12/5/15.
//  Copyright (c) 2015 gLabs. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    // Declare variables
    
    var sharedModel: AppDelegate {
        get {
            let object = UIApplication.sharedApplication().delegate as! AppDelegate
            return object
        }
    }
    
    var sentMemesCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //# MARK: - Collection View Methods
    
    // Set Collection View and reload data
    override func viewWillAppear(animated: Bool) {
        self.sentMemesCollectionView = self.view.viewWithTag(2) as! UICollectionView
        self.sentMemesCollectionView.reloadData()
    }
    
    // Return number of memes for the collection view
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = self.sharedModel.memes.count
        return numberOfItems
    }
    
    // Populate cells in the collection view
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) 
        let content: Meme = self.sharedModel.memes[indexPath.row] as Meme
        let thumbNail: UIImage = content.memedImage
        let imageView: UIImageView = item.contentView.viewWithTag(100) as! UIImageView
        imageView.image = thumbNail
        
        return item
    }
    
    // Show detail view upon selection of item
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        detailVC.meme = self.sharedModel.memes[indexPath.row]
        detailVC.memeId = indexPath.row
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }

    // Add Meme button pressed
    @IBAction func addMeme(sender: AnyObject) {
        if(self.presentingViewController != nil) {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            let startVC = self.storyboard?.instantiateInitialViewController() as! CollectionViewController
            let object = UIApplication.sharedApplication().delegate as! AppDelegate
            object.window!.rootViewController = startVC
        }

        
    }
    
    
}

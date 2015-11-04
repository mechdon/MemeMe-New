//
//  TableViewController.swift
//  MemeMe
//
//  Created by Gerard Heng on 12/5/15.
//  Copyright (c) 2015 gLabs. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    // Declare variables
    var sharedModel: AppDelegate {
        get {
            let object = UIApplication.sharedApplication().delegate as! AppDelegate
            return object
        }
    }
    
    var sentMemesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // Set tableView and reload data
    override func viewWillAppear(animated: Bool) {
        
        self.sentMemesTableView = self.view.viewWithTag(1) as! UITableView
        self.sentMemesTableView.reloadData()
    }
    
    
    //# MARK: - TableView methods
    
    // Return number of memes in number of rows in section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfMemes = self.sharedModel.memes.count
        print(numberOfMemes)
        return numberOfMemes
    }
    
    // Populate the customs cells of the tableView
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) 
        let content: Meme = self.sharedModel.memes[indexPath.row] as Meme
        let combinedtxt = content.top + " " + content.bottom
        print(combinedtxt)
        let combinedTextlabel: UILabel = cell.contentView.viewWithTag(102) as! UILabel
        combinedTextlabel.text = combinedtxt
        let cellImageView: UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        let thumbNail: UIImage = content.memedImage
        cellImageView.image = thumbNail
        
        return cell
    }
    
    // Show detail view when a particular row is selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
            let startVC = self.storyboard?.instantiateInitialViewController() as! TableViewController
            let object = UIApplication.sharedApplication().delegate as! AppDelegate
            object.window!.rootViewController = startVC
        }
    }

    
    
}

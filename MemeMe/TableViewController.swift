//
//  TableViewController.swift
//  MemeMe
//
//  Created by Gerard Heng on 12/5/15.
//  Copyright (c) 2015 gLabs. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController,  UITableViewDataSource, UITableViewDelegate {
    
    // Declare variables
    var sharedModel: AppDelegate {
        get {
            var object = UIApplication.sharedApplication().delegate as! AppDelegate
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
        var numberOfMemes = self.sharedModel.memes.count
        return numberOfMemes
    }
    
    // Populate the customs cells of the tableView
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as! UITableViewCell
        var content: Meme = self.sharedModel.memes[indexPath.row] as Meme
        var combinedtxt = content.top + " " + content.bottom
        var combinedTextlabel: UILabel = cell.contentView.viewWithTag(102) as! UILabel
        combinedTextlabel.text = combinedtxt
        var cellImageView: UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        var thumbNail: UIImage = content.memedImage
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
            var startVC = self.storyboard?.instantiateInitialViewController() as! TableViewController
            var object = UIApplication.sharedApplication().delegate as! AppDelegate
            object.window!.rootViewController = startVC
        }
    }

    
    
}

//
//  TimelineViewController.swift
//  petPals
//
//  Created by Shaun Chua on 31/10/15.
//  Copyright © 2015 Shaun Chua. All rights reserved.
//

import UIKit
import Parse
import Bond

class TimelineViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var photoTakingHelper: PhotoTakingHelper?
  var posts: [Post] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tabBarController?.delegate = self
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    ParseHelper.timelineRequestForCurrentUser {
      (result: [AnyObject]?, error: NSError?) -> Void in
      
      // In the completion block we receive all posts that meet our requirements. The Parse framework hands us an array of type [AnyObject]?. However, we would like to store the posts in an array of type [Post]. In this step we check if it is possible to cast the result into a [Post]; if that's not possible (e.g. because the result is nil) we store an empty array ([]) in self.posts. The ?? operator is called the nil coalescing operator in Swift. If the statement before this operator returns nil, the return value will be replaced with the value after the operator.
      self.posts = result as? [Post] ?? []
      
      // Once we have stored the new posts, we refresh the tableView.
      self.tableView.reloadData()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func takePhoto() {
    // instantiate photo taking class, provide callback for when photo is selected
    photoTakingHelper =
      PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
        let post = Post()
        // 1 Because image is now an Observable type, we need to store the image using the .value property.
        post.image.value = image!
        post.uploadPost()
    }
  }
}

// MARK: Tab Bar Delegate

extension TimelineViewController: UITabBarControllerDelegate {
  
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
      if (viewController is PhotoViewController) {
        takePhoto()
        return false
      } else {
        return true
      }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension TimelineViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // In this line we cast cell to our custom class PostTableViewCell. (In order to access the specific properties of our custom table view cell, we need to perform a cast to the type of our custom class. Without this cast the cell variable would have a type of a plain old UITableViewCell instead of our PostTableViewCell.)
    let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
    
    let post = posts[indexPath.row]
    // 1 Directly before a post will be displayed, we trigger the image download.
    post.downloadImage()
    // 2 Instead of changing the image that is displayed in the cell from within the TimelineViewController, we assign the post that shall be displayed to the post property. After the changes we made a few steps back, the cell now takes care of displaying the image that belongs to a Post object itself.
    cell.post = post
    
    return cell
  }

  
}
//
//  TimelineViewController.swift
//  petPals
//
//  Created by Shaun Chua on 31/10/15.
//  Copyright © 2015 Shaun Chua. All rights reserved.
//

import UIKit
import Parse

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
      (result, error: NSError?) -> Void in
      self.posts = result as? [Post] ?? []
      
      for post in self.posts {
        let data = try! post.imageFile?.getData()
        post.image = UIImage(data: data!, scale:1.0)
      }
      
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
        post.image = image
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
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // 1
    return posts.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // 1
    let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
    
    // 2
    cell.postImageView.image = posts[indexPath.row].image
    
    return cell
  }
  
}
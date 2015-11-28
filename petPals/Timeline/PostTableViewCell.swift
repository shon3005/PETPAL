//
//  PostTableViewCell.swift
//  petPals
//
//  Created by Shaun Chua on 2/11/15.
//  Copyright © 2015 Shaun Chua. All rights reserved.
//

import UIKit
import Bond
import Parse

class PostTableViewCell: UITableViewCell {
  
  
  @IBOutlet weak var likeButton: UIButton!
  @IBAction func likeButtonTapped(sender: AnyObject) {
    post?.toggleLikePost(PFUser.currentUser()!)
  }
  @IBOutlet weak var postImageView: UIImageView!
  @IBOutlet weak var moreButton: UIButton!
  @IBAction func moreButtonTapped(sender: AnyObject) {
  }
  @IBOutlet weak var likesLabel: UILabel!
  @IBOutlet weak var likesIconImageView: UIImageView!
  
  var post: Post? {
    didSet {
      // 1 Whenever a new value is assigned to the post property, we use optional binding to check whether the new value is nil.
      if let post = post {
        //2
        // If the value isn't nil, we create a binding between the image property of the post and the image property of the postImageView using the .bindTo method.
        post.image.bindTo(postImageView.bnd_image)
      }
    }
  }
  // ...
  
}
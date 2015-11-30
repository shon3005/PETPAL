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
  
  var postDisposable: DisposableType?
  var likeDisposable: DisposableType?
  
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
  
  // Generates a comma separated list of usernames from an array (e.g. "User1, User2")
  func stringFromUserList(userList: [PFUser]) -> String {
    // 1 You have already seen and used map before. As we discussed it allows you to replace objects in a collection with other objects. Typically you use map to create a different representation of the same thing. In this case we are mapping from PFUser objects to the usernames of these PFObjects.
    let usernameList = userList.map { user in user.username! }
    // 2 We now use that array of strings to create one joint string. We can do that by using the joinWithSeparator method provided by Swift. The joinWithSeparator method can be called on any array of strings. After the method is called, we have created a string of the following form: "Test User 1, Test User 2".
    let commaSeparatedUserList = usernameList.joinWithSeparator(", ")
    
    return commaSeparatedUserList
  }
  
  var post: Post? {
    didSet {
      
      // We use the disposable variables to destroy old bindings. This way we avoid that this cell listens to updates from old posts that it's no longer displaying.
      postDisposable?.dispose()
      likeDisposable?.dispose()
      
      // 1 Whenever a new value is assigned to the post property, we use optional binding to check whether the new value is nil.
      if let post = post {
        // If the value isn't nil, we create a binding between the image property of the post and the image property of the postImageView using the .bindTo method.
        postDisposable = post.image.bindTo(postImageView.bnd_image)
        
        // For binding to the likes of a post we use the observe method. The observe method is provided by the Bond framework and can be called on any object wrapped in the Observable type. The observe method takes one parameter, a closure (defined as a trailing closure in the code above), which in our case has type [PFUser]? -> (). The code defined by the closure will be executed whenever post.image receives a new value. The constant named value in the closure definition will contain the actual contents of post.likes, that is, the Observable wrapper will have been removed.
        likeDisposable = post.likes.observe { (value: [PFUser]?) -> () in
          
          // Because post.likes contains an optional array of PFUsers, we use optional binding to ensure that value is not nil.
          if let value = value {
            
            // If we have received a value, we perform different updates. First of all we update the likesLabel to display a list of usernames of all users that have liked the post. We use a utility method stringFromUserList to generate that list. We'll add and discuss that method later on!
            self.likesLabel.text = self.stringFromUserList(value)
            
            // Next we set the state of the like button (the heart) based on whether or not the current user is in the list of users that like the currently displayed post. If the user has liked the post, we want the button to be in the Selected state so that the heart appears red. If not selected will be set to false and the heart will be displayed in gray.
            self.likeButton.selected = value.contains(PFUser.currentUser()!)
            
            // Finally, if no one likes the current post, we want to hide the small heart icon displayed in front of the list of users that like a post.
            self.likesIconImageView.hidden = (value.count == 0)
          } else {
            
            // If we haven't received a value yet, set all UI elements to default values.
            self.likesLabel.text = ""
            self.likeButton.selected = false
            self.likesIconImageView.hidden = false
          }
        }
      }
    }
  }
  // ...
  
}
//
//  ParseHelper.swift
//  petPals
//
//  Created by Shaun Chua on 2/11/15.
//  Copyright © 2015 Shaun Chua. All rights reserved.
//

import Foundation
import Parse

// 1 We are going to wrap all of our helper methods into a class called ParseHelper. We only do this so that all of the functions are bundled under the ParseHelper namespace. That makes the code easier to read in some cases. To call the timeline request function you call ParseHelper.timelineRequestforUser... instead of simply timelineRequestforUser. That way you always know exactly in which file you can find the methods that are being called.
class ParseHelper {
  
  // Following Relation
  static let ParseFollowClass       = "Follow"
  static let ParseFollowFromUser    = "fromUser"
  static let ParseFollowToUser      = "toUser"
  
  // Like Relation
  static let ParseLikeClass         = "Like"
  static let ParseLikeToPost        = "toPost"
  static let ParseLikeFromUser      = "fromUser"
  
  // Post Relation
  static let ParsePostUser          = "user"
  static let ParsePostCreatedAt     = "createdAt"
  
  // Flagged Content Relation
  static let ParseFlaggedContentClass    = "FlaggedContent"
  static let ParseFlaggedContentFromUser = "fromUser"
  static let ParseFlaggedContentToPost   = "toPost"
  
  // User Relation
  static let ParseUserUsername      = "username"
  
  // 2 We mark this method as static. This means we can call it without having to create an instance of ParseHelper - you should do that for all helper methods. This method has only one parameter, completionBlock: the callback block that should be called once the query has completed. The type of this parameter is PFArrayResultBlock. That's the default type for all of the callbacks in the Parse framework. By taking this callback as a parameter, we can call any Parse method and return the result of the method to that completionBlock - you'll see how we use that in 3.
  static func timelineRequestForCurrentUser(completionBlock: PFQueryArrayResultBlock) {
    // First, we are creating the query that fetches the Follow relationships for the current user.
    let followingQuery = PFQuery(className: ParseFollowClass)
    followingQuery.whereKey(ParseLikeFromUser, equalTo:PFUser.currentUser()!)
    
    // We use that query to fetch any posts that are created by users that the current user is following
    let postsFromFollowedUsers = Post.query()
    postsFromFollowedUsers!.whereKey(ParsePostUser, matchesKey: ParseFollowToUser, inQuery: followingQuery)
    
    // We create another query to retrieve all posts that the current user has posted.
    let postsFromThisUser = Post.query()
    postsFromThisUser!.whereKey(ParsePostUser, equalTo: PFUser.currentUser()!)
    
    // We create a combined query of the 2. and 3. queries using the orQueryWithSubqueries method. The query generated this way will return any Post that meets either of the constraints of the queries in 2. or 3.
    let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
    
    // We define that the combined query should also fetch the PFUser associated with a post. As you might remember, we are storing a pointer to a user object in the user column of each post. By using the includeKey method we tell Parse to resolve that pointer and download all the information about the user along with the post. We will need the username later when we display posts in our timeline.
    query.includeKey(ParsePostUser)
    
    // We define that the results should be ordered by the createdAt field. This will make posts on the timeline appear in chronological order.
    query.orderByDescending(ParsePostCreatedAt)
    
    // We kick off the network request
    // 3 The entire body of this method is unchanged, it's the exact timeline query that we've built within the TimelineViewController. The only difference is the last line of the method. Instead of providing a closure and handling the results of the query within this method, we hand off the results to the closure that has been handed to use through the completionBlock parameter. This means whoever calls the timelineRequestForCurrentUser method will be able to handle the result returned from the query!
    query.findObjectsInBackgroundWithBlock(completionBlock)
  }
  
  static func likePost(user: PFUser, post: Post) {
    let likeObject = PFObject(className: ParseLikeClass)
    likeObject[ParseLikeFromUser] = user
    likeObject[ParseLikeToPost] = post
    
    likeObject.saveInBackgroundWithBlock(nil)
  }
  
  static func unlikePost(user: PFUser, post: Post) {
    // 1 We build a query to find the like of a given user that belongs to a given post
    let query = PFQuery(className: ParseLikeClass)
    query.whereKey(ParseLikeFromUser, equalTo: user)
    query.whereKey(ParseLikeToPost, equalTo: post)
    
    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
      // 2 We iterate over all like objects that met our requirements and delete them.
      if let results = results as? [PFObject]! {
        for likes in results {
          likes.deleteInBackgroundWithBlock(nil)
        }
      }
    }
  }
  
  // 1 Our method is taking a PFArrayResultBlock as an argument. We've used the same approach in our timelineRequestForCurrentUser method. The PFArrayResultBlock has the following signature:([AnyObject]?, NSError?) -> Void
  static func likesForPost(post: Post, completionBlock: PFQueryArrayResultBlock) {
    let query = PFQuery(className: ParseLikeClass)
    query.whereKey(ParseLikeToPost, equalTo: post)
    // 2 We are using the includeKey method to tell Parse to fetch the PFUser object for each of the likes (we've discussed includeKey in detail when building the timeline request). We want to fetch the PFUser along with the likes because later on we want to display the usernames of all users that have liked a post. Remember, without the includeKey line, we would just have a reference to a PFUser and would have to start a separate request to fetch the information about the user.
    query.includeKey(ParseLikeFromUser)
    
    query.findObjectsInBackgroundWithBlock(completionBlock)
  }
  
}
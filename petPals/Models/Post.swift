//
//  Post.swift
//  petPals
//
//  Created by Shaun Chua on 31/10/15.
//  Copyright © 2015 Shaun Chua. All rights reserved.
//

import Foundation
import Parse
import Bond

// 1 To create a custom Parse class you need to inherit from PFObject and implement the PFSubclassing protocol
class Post : PFObject, PFSubclassing {
  
  var photoUploadTask: UIBackgroundTaskIdentifier?
  var image: Observable<UIImage?> = Observable(nil)
  var likes: Observable<[PFUser]?> = Observable(nil)
  
  // 2 Next, define each property that you want to access on this Parse class. For our Post class that's the user and the imageFile of a post. That will allow you to change the code that accesses properties through strings: post["imageFile"] = imageFile Into code that uses Swift properties: post.imageFile = imageFile
  @NSManaged var imageFile: PFFile?
  @NSManaged var user: PFUser?
  
  
  //MARK: PFSubclassing Protocol
  
  // 3 By implementing the parseClassName you create a connection between the Parse class and your Swift class.
  static func parseClassName() -> String {
    return "Post"
  }
  
  // 4 init and initialize are pure boilerplate code - copy these two into any custom Parse class that you're creating.
  override init () {
    super.init()
  }
  
  override class func initialize() {
    var onceToken : dispatch_once_t = 0;
    dispatch_once(&onceToken) {
      // inform Parse about this subclass
      self.registerSubclass()
    }
  }
  
  func uploadPost() {
    
    if let image = image.value {
      
      // As soon as a post gets uploaded we create a background task. When a background task gets created iOS generates a unique ID and returns it. We store that unique id in the photoUploadTask property. The API requires us to provide an expirationHandler in the form of a closure. That closure runs when the extra time that iOS permitted us has expired. In case the additional background time wasn't sufficient, we are required to cancel our task! Within this block you should delete any temporary resources that you created - in the case of our photo upload we don't have any. Additionally you have to call UIApplication.sharedApplication().endBackgroundTask, otherwise your app will be terminated!
      photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
        () -> Void in
        // Within the completion handler of saveInBackgroundWithBlock we inform iOS that our background task is completed. This block gets called as soon as the image upload is finished. The API for background jobs makes us responsible for calling UIApplication.sharedApplication().endBackgroundTask as soon as our work is completed.
        UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
      }
      
      let imageData = UIImageJPEGRepresentation(image, 0.8)
      let imageFile = PFFile(data: imageData!)
      
      // After we've created the background task we save the imageFile by calling saveInBackgroundWithBlock; however, this time we aren't handing nil as a completion handler!
      imageFile.saveInBackgroundWithBlock(nil)
      
      user = PFUser.currentUser()
      self.imageFile = imageFile
      saveInBackgroundWithBlock {
        (success: Bool, error: NSError?) -> Void in
        UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
      }
    }
  }
  
  func downloadImage() {
    // if image is not downloaded yet, get it
    // 1 First, we check if image.value already has a stored value. We do this to avoid downloading images multiple times. (We only want to start the donwload if image.value is nil.)
    if (image.value == nil) {
      // 2 Here we start the download. Instead of using getData we are using getDataInBackgroundWithBlock - that way we are no longer blocking the main thread!
      imageFile?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
        if let data = data {
          let image = UIImage(data: data, scale:1.0)!
          // 3 Once the download completes, we update the post.image. Note that we are now using the .value property, because image is an Observable.
          self.image.value = image
        }
      }
    }
  }
  
  func fetchLikes() {
    // 1 First we are checking whether likes.value already has stored a value or is nil. If we've already stored a value, we will skip the entire method. As discussed, we will cache all likes until the entire timeline is refreshed (which we haven't implemented yet). So as soon as likes.value has a cached value, we don't need to perform the body of this method.
    if (likes.value != nil) {
      return
    }
    
    // 2 We fetch the likes for the current Post using the method of ParseHelper that we created earlier
    ParseHelper.likesForPost(self, completionBlock: { (var likes, error: NSError?) -> Void in
      // 3 There is a new concept on this line: the filter method that we call on our Array. The filter method takes a closure and returns an array that only contains the objects from the original array that meet the requirement stated in that closure. The closure passed to the filter method gets called for each element in the array, each time passing the current element as the like argument to the closure. Note that you can pick any arbitrary name for the argument that we called like. So why are we filtering the array in the first place? We are removing all likes that belong to users that no longer exist in our Makestagram app (because their account has been deleted). Without this filtering the next statement could crash.
      likes = likes?.filter { like in like[ParseHelper.ParseLikeFromUser] != nil }
      
      // 4 Here we are again using a new method: map. The map method behaves similar to the filter method in that it takes a closure that is called for each element in the array and in that it also returns a new array as a result. The difference is that, unlike filter, map does not remove objects but replaces them. In this particular case we are replacing the likes in the array with the users that are associated with the like. We start with an array of likes and retrieve an array of users. Then we assign the result to our likes.value property.
      self.likes.value = likes?.map { like in
        let like = like as! PFObject
        let fromUser = like[ParseHelper.ParseLikeFromUser] as! PFUser
        
        return fromUser
      }
    })
  }
  
  func doesUserLikePost(user: PFUser) -> Bool {
    if let likes = likes.value {
      return likes.contains(user)
    } else {
      return false
    }
  }
  
  func toggleLikePost(user: PFUser) {
    if (doesUserLikePost(user)) {
      // if image is liked, unlike it now
      // 1 If the toggleLikePost method is called and a user likes a post, we unlike the post. First by removing the user from the local cache stored in the likes property, then by syncing the change with Parse. We remove the user from the local cache by using the filter method on the array stored in likes.value.
      likes.value = likes.value?.filter { $0 != user }
      ParseHelper.unlikePost(user, post: self)
    } else {
      // if this image is not liked yet, like it now
      // 2 If the user doesn't like the post yet, we add them to the local cache and then synch the change with Parse.
      likes.value?.append(user)
      ParseHelper.likePost(user, post: self)
    }
  }
  
}
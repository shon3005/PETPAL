//
//  Post.swift
//  petPals
//
//  Created by Shaun Chua on 31/10/15.
//  Copyright © 2015 Shaun Chua. All rights reserved.
//

import Foundation
import Parse

// 1
class Post : PFObject, PFSubclassing {
  
  var photoUploadTask: UIBackgroundTaskIdentifier?
  var image: UIImage?
  
  // 2
  @NSManaged var imageFile: PFFile?
  @NSManaged var user: PFUser?
  
  
  //MARK: PFSubclassing Protocol
  
  // 3
  static func parseClassName() -> String {
    return "Post"
  }
  
  // 4
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
    let imageData = UIImageJPEGRepresentation(image!, 0.8)
    let imageFile = PFFile(data: imageData!)
    
    // 1
    photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
      UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
    }
    
    // 2
    imageFile.saveInBackgroundWithBlock { (success, error) -> Void in
      // 3
      UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
    }
    
    // any uploaded post should be associated with the current user
    user = PFUser.currentUser()
    self.imageFile = imageFile
    saveInBackgroundWithBlock(nil)
  }
  
}
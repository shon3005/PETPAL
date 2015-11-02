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
    if let image = image {
      // 1
      let imageData = UIImageJPEGRepresentation(image, 0.8)!
      let imageFile = PFFile(data: imageData)
      try! imageFile.save()
      // 2
      self.imageFile = imageFile
      try! save()
    }
  }
  
}
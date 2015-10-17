//
//  Profile.swift
//  petPals
//
//  Created by Shaun Chua on 3/10/15.
//  Copyright © 2015 Shaun Chua. All rights reserved.
//

import UIKit

class Profile: NSObject {
  var name: String?
  var username: String?
  var aboutMe: String?
  var website: String?
  var email: String?
  var phone: String?
  var gender: String?
  
  init(name: String? = nil, phone: String? = nil, username: String? = nil, gender: String? = nil, email: String? = nil, aboutMe: String? = nil, website: String? = nil) {
    self.name = name
    self.phone = phone
    self.username = username
    self.gender = gender
    self.email = email
    self.aboutMe = aboutMe
    self.website = website
    super.init()
  }
  
}
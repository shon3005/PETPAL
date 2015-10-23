//
//  PetProfile.swift
//  petPals
//
//  Created by Shaun Chua on 22/10/15.
//  Copyright © 2015 Shaun Chua. All rights reserved.
//

import Foundation

class PetProfile {
  class Entry {
    let filename: String
    let heading: String
    init(fname: String, heading: String) {
      self.heading = heading
      self.filename = fname
    }
  }
}
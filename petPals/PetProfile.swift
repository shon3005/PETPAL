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
    let petName: String
    let petBreed: String
    let filename: String
    init(petName: String, petBreed: String, fname: String) {
      self.filename = fname
      self.petName = petName
      self.petBreed = petBreed
    }
  }
  
  let petProfiles = [
    Entry(petName: "Marshall", petBreed: "ChowChow", fname: "chua_shaun_profile.jpg"),
    Entry(petName: "Po", petBreed: "ChowChow", fname: "chua_shaun_profile.jpg"),
    Entry(petName: "XiaoMing", petBreed: "Persian", fname: "chua_shaun_profile.jpg"),
    Entry(petName: "Alpha", petBreed: "Boz Shepherd", fname: "chua_shaun_profile.jpg")
  ]
}
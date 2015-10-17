//
//  EditProfileController.swift
//  petPals
//
//  Created by Shaun Chua on 3/10/15.
//  Copyright © 2015 Shaun Chua. All rights reserved.
//

import UIKit

class EditProfileController: UITableViewController, UITextFieldDelegate{
  
  
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var websiteField: UITextField!
  @IBOutlet weak var aboutMeField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var phoneField: UITextField!
  @IBOutlet weak var genderField: UITextField!
  
  var profile: Profile?
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let profile = self.profile {
      if let name = profile.name {
        nameField.placeholder = "Name"
        nameField.text = name
        //nameField.delegate = self
      }
      if let username = profile.username {
        usernameField.text = "Username"
        usernameField.text = username
        //usernameField.delegate = self
      }
      if let website = profile.website {
        websiteField.placeholder = "Website"
        websiteField.text = website
        //websiteField.delegate = self
      }
      if let aboutMe = profile.aboutMe {
        aboutMeField.placeholder = "About Me"
        aboutMeField.text = aboutMe
        //aboutMeField.delegate = self
      }
      if let email = profile.email {
        emailField.placeholder = "Email"
        emailField.text = email
        //emailField.delegate = self
      }
      if let phone = profile.phone {
        phoneField.placeholder = "Phone"
        phoneField.text = phone
        //phoneField.delegate = self
      }
      if let gender = profile.gender {
        genderField.placeholder = "Gender"
        genderField.text = gender
        //genderField.delegate = self
      }
    }
    
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    if textField == self.nameField {
      self.profile?.name = textField.text
    }
    else if textField == self.usernameField {
      self.profile?.username = textField.text
    }
    else if textField == self.websiteField {
      self.profile?.website = textField.text
    }
    else if textField == self.aboutMeField {
      self.profile?.aboutMe = textField.text
    }
    else if textField == self.emailField {
      self.profile?.email = textField.text
    }
    else if textField == self.phoneField {
      self.profile?.phone = textField.text
    }
    else {
      self.profile?.gender = textField.text
    }
  }
  
  // make the keyboard disappear after pressing the return button on the keyboard
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    nameField.resignFirstResponder()
    usernameField.resignFirstResponder()
    websiteField.resignFirstResponder()
    aboutMeField.resignFirstResponder()
    emailField.resignFirstResponder()
    phoneField.resignFirstResponder()
    genderField.resignFirstResponder()
    
    return false
  }
  
  // touching any other part of the screen will make the keyboard disappear
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
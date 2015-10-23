//
//  FirstViewController.swift
//  petPals
//
//  Created by Shaun Chua on 30/9/15.
//  Copyright © 2015 Shaun Chua. All rights reserved.
//

import UIKit
import Parse

class FirstViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {
  
  var shon3005 = Profile(name: "Shaun Chua", username: "shon3005", website: "hello.me", aboutMe: "LOL", email: "shaun.chua@nyu.edu", phone: "(347) 302-0851", gender: "Male")
  var items: [String] = ["Dog1", "Dog2", "Dog3","Dog4", "Dog5", "Dog6","Dog1", "Dog2", "Dog3","Dog1", "Dog2", "Dog3","Dog1", "Dog2", "Dog3","Dog1", "Dog2", "Dog3"]
  var items1: [String] = ["Dog1", "Dog2", "Dog3","Dog4", "Dog5", "Dog6","Dog1", "Dog2", "Dog3","Dog1", "Dog2", "Dog3","Dog1", "Dog2", "Dog3","Dog1", "Dog2", "Dog3"]
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var websiteLabel: UILabel!
  @IBOutlet weak var aboutMeLabel: UILabel!
  @IBOutlet weak var tableViewPetProfiles: UITableView!
  
  override func viewDidAppear(animated: Bool) {
    
    super.viewDidAppear(animated)
    nameLabel.text = shon3005.name
    websiteLabel.text = shon3005.website
    aboutMeLabel.text = shon3005.aboutMe
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableViewPetProfiles.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    // Do any additional setup after loading the view, typically from a nib.
    let name = shon3005.name
    nameLabel.text = name
    let website = shon3005.website
    websiteLabel.text = website
    let aboutMe = shon3005.aboutMe
    aboutMeLabel.text = aboutMe
    
    let user = PFUser()
    user.username = "shon3005"
    user.email = "shaun.chua@nyu.edu"
    
    // other fields can be set if you want to save more information
    user["phone"] = "650-555-0000"
    user["name"] = "Shaun Chua"
    user["gender"] = "Male"
    user["website"] = "hello.me"
    user["aboutMe"] = "LOL"
    
    user.signUpInBackgroundWithBlock { (success, error) -> Void in
      if error == nil {
        // Hooray! Let them use the app now.
      } else {
        // Examine the error object and inform the user.
      }
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)!
    //let profile = self.profile[indexPath.row]
    var destination = segue.destinationViewController as! EditProfileController
    destination.profile = shon3005
  }

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return self.items.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! PetListTableViewCell
    
    cell.petName?.text = items[indexPath.row]
    cell.petBreed?.text = items1[indexPath.row]
    //cell.detailTextLabel?.text = items1[indexPath.row]
    
    return cell
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Pets"
  }

}


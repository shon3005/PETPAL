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
  
  // instantiate pet profiles
  let petProfile = PetProfile()
  
  // instantiate human profile
  var shon3005 = Profile(name: "Shaun Chua", username: "shon3005", website: "hello.me", aboutMe: "LOL", email: "shaun.chua@nyu.edu", phone: "(347) 302-0851", gender: "Male")
  
  // iboutlets used
  @IBOutlet weak var followerCount: UILabel!
  @IBOutlet weak var followingCount: UILabel!
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
    //self.tableViewPetProfiles.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell1")
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = shon3005.username
    
    // follower and following count to appear when app is first run
    followerCount.text = "15"
    followingCount.text = "15"
    
    // default info appears when app is first run
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
    
    //determine which segue identifier is being used
    if (segue.identifier == "editProfile") {
      var userDestination = segue.destinationViewController as! EditProfileController
      userDestination.profile = shon3005
    }
    else if (segue.identifier == "petProfile") {
      var petDestination = segue.destinationViewController as! PetProfileViewController
      
      if let indexPath = tableViewPetProfiles.indexPathForSelectedRow {
        let selectedProfile = petProfile.petProfiles[indexPath.row]
        petDestination.petProfile = selectedProfile
      }
      //petDestination.profile = petProfile.petProfiles[indexPath.row]
    }
  }

  // number of sections in the table view
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  // number of pet profiles created in the table view
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return petProfile.petProfiles.count
  }
  
  // each cell in the table view has information about the pet profile
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! PetListTableViewCell
    
    let entry = petProfile.petProfiles[indexPath.row]
    let image = UIImage(named: entry.filename)
    cell.petPhoto.image = image
    cell.petName.text = entry.petName
    cell.petBreed.text = entry.petBreed
    //cell.petName?.text = items[indexPath.row]
    //cell.petBreed?.text = items1[indexPath.row]
    //cell.detailTextLabel?.text = items1[indexPath.row]
    
    return cell
  }
  
  // cell height is 200
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
  {
    return 200.0; //Choose your custom row height
  }
  
  // table view header is Pets
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Pets"
  }

}


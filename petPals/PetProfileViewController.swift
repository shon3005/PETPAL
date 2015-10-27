//
//  PetProfileViewController.swift
//  petPals
//
//  Created by Shaun Chua on 26/10/15.
//  Copyright © 2015 Shaun Chua. All rights reserved.
//

import UIKit

class PetProfileViewController: UIViewController {

  @IBOutlet weak var petPhotoView: UIImageView!
  @IBOutlet weak var petNameLabel: UILabel!
  @IBOutlet weak var petBreedLabel: UILabel!
  
  var petProfile : PetProfile.Entry?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      if let petProfile = self.petProfile {
        //if let petName = petProfile.petName {
          //petNameLabel.text = petName
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

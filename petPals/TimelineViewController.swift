//
//  TimelineViewController.swift
//  petPals
//
//  Created by Shaun Chua on 31/10/15.
//  Copyright © 2015 Shaun Chua. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
  
  var photoTakingHelper: PhotoTakingHelper?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tabBarController?.delegate = self
  }

  func takePhoto() {
    // instantiate photo taking class, provide callback for when photo  is selected
    let photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
      // don't do anything, yet...
    }
  }
}

// MARK: Tab Bar Delegate

extension TimelineViewController: UITabBarControllerDelegate {
  
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
      if (viewController is PhotoViewController) {
        takePhoto()
        return false
      } else {
        return true
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

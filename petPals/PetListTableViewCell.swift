//
//  PetListTableViewCell.swift
//  petPals
//
//  Created by Shaun Chua on 22/10/15.
//  Copyright © 2015 Shaun Chua. All rights reserved.
//

import UIKit

class PetListTableViewCell: UITableViewCell {

  @IBOutlet weak var petPhoto: UIImageView!
  @IBOutlet weak var petName: UILabel!
  @IBOutlet weak var petBreed: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  PhotoTableCell.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/19/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import UIKit

class PhotoTableCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

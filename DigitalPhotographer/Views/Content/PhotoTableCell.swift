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
        
        photo.makeRoundCorners()
        userimage.makeCircle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        clearContent()
    }
    
    func clearContent() {
        photo.image = nil
        likes.text = nil
        username.text = nil
        userimage.image = nil
    }
    
}

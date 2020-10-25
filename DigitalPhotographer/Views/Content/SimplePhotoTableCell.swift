//
//  SimplePhotoTableCell.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/25/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import UIKit

class SimplePhotoTableCell: UITableViewCell {
    
    @IBOutlet weak var photoImV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoImV.makeRoundCorners()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override func prepareForReuse() {
        clearContent()
    }
    
    func clearContent() {
        photoImV.image = nil
    }
    
}

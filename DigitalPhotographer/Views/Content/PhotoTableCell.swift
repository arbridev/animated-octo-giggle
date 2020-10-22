//
//  PhotoTableCell.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/19/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import UIKit

protocol PhotoTableCellDelegate {
    func goToPhoto(indexPath: IndexPath)
    func goToUser(indexPath: IndexPath)
    func setFavorite(indexPath: IndexPath)
}

class PhotoTableCell: UITableViewCell {
    
    var indexPath: IndexPath!
    var delegate: PhotoTableCellDelegate?

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
        indexPath = nil
        delegate = nil
    }
    
    func isFavorite(_ fav: Bool) {
        if fav {
            self.favoriteBtn.setImage(UIImage(named: "heartfilled"), for: .normal)
        } else {
            self.favoriteBtn.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
    
    @IBAction func goToPhoto(_ sender: UIButton) {
        delegate?.goToPhoto(indexPath: indexPath)
    }
    
    @IBAction func goToUser(_ sender: UIButton) {
        delegate?.goToUser(indexPath: indexPath)
    }
    
    @IBAction func setFavorite(_ sender: UIButton) {
        delegate?.setFavorite(indexPath: indexPath)
    }
    
}

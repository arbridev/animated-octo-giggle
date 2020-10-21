//
//  HomeVC.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/18/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController {
    
    let network = UnsplashAPIHandler()
    let cellIdentifier = "PhotoTableCell"
    var photos: Photos?

    @IBOutlet weak var photoTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoTable.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        photoTable.dataSource = self
        photoTable.delegate = self

        let parameters = [String:String]()
        network.photos(parameters: parameters) { (responseStr, photos, error) in
            if error == nil {
                if photos == nil {
                    fatalError("Could not serialize")
                }
                self.photos = photos
                self.photoTable.reloadData()
            } else {
                print("Could not fetch photos")
            }
        }
    }

}

extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let photos = self.photos {
            return photos.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! PhotoTableCell
        if let photos = self.photos {
            let photo = photos[indexPath.row]
            cell.likes.text = "\(photo.likes)"
            cell.username.text = photo.user.name
            cell.photo.kf.setImage(with: URL(string: photo.urls.full))
            cell.userimage.kf.setImage(with: URL(string: photo.user.profileImage.medium))
            cell.indexPath = indexPath
            cell.delegate = self
        }
        return cell
    }
    
}

extension HomeVC: UITableViewDelegate {
    
}

extension HomeVC: PhotoTableCellDelegate {
    
    func goToPhoto(indexPath: IndexPath) {
        print("goToPhoto", indexPath)
        self.performSegue(withIdentifier: "PhotoVC", sender: photos![indexPath.row])
    }
    
    func goToUser(indexPath: IndexPath) {
        print("goToUser", indexPath)
        self.performSegue(withIdentifier: "UserVC", sender: photos![indexPath.row])
    }
    
    func setFavorite(indexPath: IndexPath) {
        print("setFavorite", indexPath)
    }
    
}

//
//  HomeVC.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/18/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class HomeVC: UIViewController {
    
    let network = UnsplashAPIHandler()
    let cellIdentifier = "PhotoTableCell"
    var photos: Photos?
    var favoriteRows: [Int]!

    @IBOutlet weak var photoTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoTable.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        photoTable.dataSource = self
        photoTable.delegate = self
        
        favoriteRows = [Int]()

        let parameters = [String:String]()
        network.photos(parameters: parameters) { (responseStr, photos, error) in
            if error == nil {
                if photos == nil {
                    fatalError("Could not serialize")
                }
                self.photos = photos
                self.reloadData()
            } else {
                print("Could not fetch photos")
            }
        }
        
        if let tabBar = self.tabBarController?.tabBar {
            for item in tabBar.items ?? [UITabBarItem]() {
                item.title = ""
//                item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }
    }
    
    func reloadData() {
        if let photos = self.photos {
            favoriteRows.removeAll()
            for (index, photo) in photos.enumerated() {
                if checkPhotoIsFavorite(photo) {
                    favoriteRows.append(index)
                }
            }
        }
        self.photoTable.reloadData()
    }
    
    func checkPhotoIsFavorite(_ photo: Photo) -> Bool {
        let realm = try! Realm()
        let favoritePhotos = realm.objects(Favorite.self).filter("photoID == '\(photo.id)'")
        return favoritePhotos.count > 0
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
            cell.isFavorite(favoriteRows.contains(indexPath.row))
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
        
        let cell = photoTable.cellForRow(at: indexPath) as! PhotoTableCell
        if let photos = self.photos {
            let photo = photos[indexPath.row]
            let realm = try! Realm()
            let favoritePhotos = realm.objects(Favorite.self).filter("photoID == '\(photo.id)'")
            
            if favoritePhotos.count == 0 { // Not in favorites
                // Include
                let favPhoto = Favorite()
                favPhoto.photoID = photo.id
                favPhoto.url = photo.urls.full
                favPhoto.username = photo.user.name
                favPhoto.userProfileImage = photo.user.profileImage.medium
                favPhoto.likes = photo.likes
                try! realm.write {
                    realm.add(favPhoto)
                    self.favoriteRows.append(indexPath.row)
                    DispatchQueue.main.async {
                        cell.isFavorite(true)
                    }
                }
            } else { // In favorites
                // Remove
                let favPhoto = favoritePhotos.first!
                try! realm.write {
                    realm.delete(favPhoto)
                    self.favoriteRows.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        cell.isFavorite(false)
                    }
                }
            }
        }
        
    }
    
}

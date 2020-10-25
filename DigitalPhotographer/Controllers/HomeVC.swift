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

class HomeVC: UIViewController, HUDShowing {
    
    let network = UnsplashAPIHandler()
    let cellIdentifier = "PhotoTableCell"
    var photos: Photos?
    var favoriteRows: [Int]!
    
    private var hudState: HUDState = .isHiding

    @IBOutlet weak var photoTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoTable.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        photoTable.dataSource = self
        
        favoriteRows = [Int]()
        
        self.showHUD(title: nil)
        hudState = .isShowing

        let parameters = [String:String]()
        network.photos(parameters: parameters) { (responseStr, photos, error) in
            self.hideHUD()
            self.hudState = .isHiding
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
                item.imageInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PhotoVC":
            let vc = segue.destination as! PhotoVC
            let data = sender as! PhotoVC.PhotoVCData
            vc.dataInit(data: data)
        case "UserVC":
            let vc = segue.destination as! UserVC
            let data = sender as! UserVC.UserVCData
            vc.dataInit(data: data)
        default:
            fatalError("Segue was not set")
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
            cell.isFavorite(favoriteRows.contains(indexPath.row))
        }
        return cell
    }
    
}

extension HomeVC: PhotoTableCellDelegate {
    
    func goToPhoto(indexPath: IndexPath) {
        print("goToPhoto", indexPath)
        let cell = self.photoTable.cellForRow(at: indexPath) as! PhotoTableCell
        if let photos = self.photos {
            let photo = photos[indexPath.row]
            let data = PhotoVC.PhotoVCData(photoID: photo.id, photoImage: cell.imageView?.image, userProfileImage: cell.userimage?.image)
            self.performSegue(withIdentifier: "PhotoVC", sender: data)
        }
    }
    
    func goToUser(indexPath: IndexPath) {
        print("goToUser", indexPath)
        let cell = self.photoTable.cellForRow(at: indexPath) as! PhotoTableCell
        if let photos = self.photos {
            let photo = photos[indexPath.row]
            let data = UserVC.UserVCData(username: photo.user.username, userProfileImage: cell.userimage.image)
            self.performSegue(withIdentifier: "UserVC", sender: data)
        }
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
                favPhoto.username = photo.user.username
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

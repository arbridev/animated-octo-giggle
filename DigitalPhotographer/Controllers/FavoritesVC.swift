//
//  FavoritesVC.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/18/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import UIKit
import RealmSwift

class FavoritesVC: UIViewController {
    
    let network = UnsplashAPIHandler()
    let cellIdentifier = "PhotoTableCell"
    var favorites: [Favorite]?

    @IBOutlet weak var photoTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoTable.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        photoTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let realm = try! Realm()
        self.favorites = Array(realm.objects(Favorite.self))
        self.photoTable.reloadData()
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

extension FavoritesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let favorites = self.favorites {
            return favorites.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! PhotoTableCell
        if let favorites = self.favorites {
            let favorite = favorites[indexPath.row]
            cell.likes.text = "\(favorite.likes)"
            cell.username.text = favorite.username
            cell.photo.kf.setImage(with: URL(string: favorite.url))
            cell.userimage.kf.setImage(with: URL(string: favorite.userProfileImage))
            cell.indexPath = indexPath
            cell.delegate = self
            cell.isFavorite(true)
        }
        return cell
    }
    
}

// MARK: - PhotoTableCellDelegate

extension FavoritesVC: PhotoTableCellDelegate {
    
    func goToPhoto(indexPath: IndexPath) {
        print("goToPhoto", indexPath)
        let cell = self.photoTable.cellForRow(at: indexPath) as! PhotoTableCell
        if let favorites = self.favorites {
            let favorite = favorites[indexPath.row]
            let data = PhotoVC.PhotoVCData(photoID: favorite.photoID, photoImage: cell.imageView?.image, userProfileImage: cell.userimage?.image)
            self.performSegue(withIdentifier: "PhotoVC", sender: data)
        }
    }
    
    func goToUser(indexPath: IndexPath) {
        print("goToUser", indexPath)
        let cell = self.photoTable.cellForRow(at: indexPath) as! PhotoTableCell
        if let favorites = self.favorites {
            let favorite = favorites[indexPath.row]
            let data = UserVC.UserVCData(username: favorite.username, userProfileImage: cell.userimage.image)
            self.performSegue(withIdentifier: "UserVC", sender: data)
        }
    }
    
    func setFavorite(indexPath: IndexPath) {
        print("setFavorite", indexPath)
        let cell = photoTable.cellForRow(at: indexPath) as! PhotoTableCell
        if let favorites = self.favorites {
            let favorite = favorites[indexPath.row]
            let realm = try! Realm()
            try! realm.write {
                realm.delete(favorite)
                self.favorites?.remove(at: indexPath.row)
                self.photoTable.deleteRows(at: [indexPath], with: .bottom)
                DispatchQueue.main.async {
                    cell.isFavorite(false)
                }
            }
        }
        
    }
    
}

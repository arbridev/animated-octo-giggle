//
//  HomeVC.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/18/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import UIKit

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
            cell.photo.downloadImageFrom(link: photo.urls.full, contentMode: .scaleAspectFill)
            cell.likes.text = "\(photo.likes)"
            cell.username.text = photo.user.name
            cell.userimage.downloadImageFrom(link: photo.user.profileImage.medium, contentMode: .scaleAspectFit)
        }
        return cell
    }
    
}

extension HomeVC: UITableViewDelegate {
    
}

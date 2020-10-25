//
//  PhotoVC.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/18/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class PhotoVC: UIViewController, HUDShowing {
    
    struct PhotoVCData {
        var photoID: String
        var photoImage: UIImage?
        var userProfileImage: UIImage?
    }
    
    let network = UnsplashAPIHandler()
    var initData: PhotoVCData!
    var photo: Photo?
    var networkLoads: Int = 0
    
    private var hudState: HUDState = .isHiding

    @IBOutlet weak var photoImV: UIImageView!
    
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    @IBOutlet weak var viewsTotal: UILabel!
    @IBOutlet weak var viewsHistorical: UILabel!
    @IBOutlet weak var likesTotal: UILabel!
    @IBOutlet weak var likesHistorical: UILabel!
    @IBOutlet weak var downloadsTotal: UILabel!
    @IBOutlet weak var downloadsHistorical: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userProfileImage.makeCircle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startNetworkLoad()
    }
    
    func dataInit(data: PhotoVCData) {
        initData = data
    }
    
    func startNetworkLoad() {
        networkLoads = 2
        self.showHUD(title: nil)
        hudState = .isShowing
        
        network.photo(parameters: [String:String](), embeddedParams: ["id":initData.photoID]) { (response, photo, error) in
            self.checkNetworkLoad()
            
            if let photo = photo {
                self.photo = photo
                self.likes.text = "\(photo.likes)"
                self.usernameLbl.text = photo.user.name
                if let photoImage = self.initData.photoImage {
                    self.photoImV.image = photoImage
                } else {
                    self.photoImV.kf.setImage(with: URL(string: photo.urls.full))
                }
                if let userProfileImage = self.initData.userProfileImage {
                    self.userProfileImage.image = userProfileImage
                } else {
                    self.userProfileImage.kf.setImage(with: URL(string: photo.user.profileImage.medium))
                }
            }
        }
        
        network.photoStatistics(parameters: [String:String](), embeddedParams: ["id":initData.photoID]) { (response, photoStatistics, error) in
            self.checkNetworkLoad()
            
            if let statistics = photoStatistics {
                self.viewsTotal.text = "\(statistics.views.total)"
                self.viewsHistorical.text = "\(statistics.views.historical.change) views the last \(statistics.views.historical.quantity) \(statistics.views.historical.resolution)"
                
                self.likesTotal.text = "\(statistics.likes.total)"
                self.likesHistorical.text = "\(statistics.likes.historical.change) likes the last \(statistics.likes.historical.quantity) \(statistics.likes.historical.resolution)"
                
                self.downloadsTotal.text = "\(statistics.downloads.total)"
                self.downloadsHistorical.text = "\(statistics.downloads.historical.change) downloads the last \(statistics.downloads.historical.quantity) \(statistics.downloads.historical.resolution)"
            }
        }
    }
    
    func checkNetworkLoad() {
        networkLoads -= 1
        if networkLoads == 0 {
            self.hideHUD()
            self.hudState = .isHiding
        }
    }
    
    func checkPhotoIsFavorite(_ photo: Photo) -> Bool {
        let realm = try! Realm()
        let favoritePhotos = realm.objects(Favorite.self).filter("photoID == '\(photo.id)'")
        return favoritePhotos.count > 0
    }
    
    func isFavorite(_ fav: Bool) {
        if fav {
            self.favoriteBtn.setImage(UIImage(named: "heartfilled"), for: .normal)
        } else {
            self.favoriteBtn.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setFavorite(_ sender: UIButton) {
        if let photo = self.photo {
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
                    DispatchQueue.main.async {
                        self.isFavorite(true)
                    }
                }
            } else { // In favorites
                // Remove
                let favPhoto = favoritePhotos.first!
                try! realm.write {
                    realm.delete(favPhoto)
                    DispatchQueue.main.async {
                        self.isFavorite(false)
                    }
                }
            }
            
        }
    }
    
    @IBAction func goToUser(_ sender: UIButton) {
        
    }

}

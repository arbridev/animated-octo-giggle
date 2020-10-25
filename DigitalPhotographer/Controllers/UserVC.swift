//
//  UserVC.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/18/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import UIKit

class UserVC: UIViewController, HUDShowing {
    
    struct UserVCData {
        var username: String
        var userProfileImage: UIImage?
    }
    
    let network = UnsplashAPIHandler()
    let cellIdentifier = "SimplePhotoTableCell"
    var initData: UserVCData!
    var user: User?
    var photos: UserPhotos?
    var networkLoads: Int = 0
    
    private var hudState: HUDState = .isHiding

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var totalPhotos: UILabel!
    @IBOutlet weak var totalCollections: UILabel!
    @IBOutlet weak var totalLikes: UILabel!
    @IBOutlet weak var photoTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoTable.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        photoTable.dataSource = self

        userImage.makeCircle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startNetworkLoad()
    }
    
    func dataInit(data: UserVCData) {
        initData = data
    }
    
    func startNetworkLoad() {
        networkLoads = 2
        self.showHUD(title: nil)
        hudState = .isShowing
        
        network.userProfile(parameters: [String:String](), embeddedParams: ["username":initData.username]) { (response, userProfile, error) in
            self.checkNetworkLoad()
            
            if let userProfile = userProfile {
                self.username.text = "\(userProfile.name ?? "")"
                self.bioLbl.text = userProfile.bio
                self.totalPhotos.text = "\(userProfile.totalPhotos)"
                self.totalLikes.text = "\(userProfile.totalLikes)"
                self.totalCollections.text = "\(userProfile.totalCollections)"
                if let userProfileImage = self.initData.userProfileImage {
                    self.userImage.image = userProfileImage
                } else {
                    self.userImage.kf.setImage(with: URL(string: userProfile.profileImage.medium))
                }
            }
        }
        
        network.userPhotos(parameters: [String:String](), embeddedParams: ["username":initData.username]) { (response, userPhotos, error) in
            self.checkNetworkLoad()
            
            if let userPhotos = userPhotos {
                self.photos = userPhotos
                self.photoTable.reloadData()
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
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension UserVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let photos = self.photos {
            return photos.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SimplePhotoTableCell
        if let photos = self.photos {
            let photo = photos[indexPath.row]
            cell.photoImV.kf.setImage(with: URL(string: photo.urls.full))
        }
        return cell
    }
    
}

//
//  Favorite.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/21/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import Foundation
import RealmSwift

class Favorite: Object {
    @objc dynamic var photoID = ""
    @objc dynamic var url = ""
    @objc dynamic var username = ""
    @objc dynamic var userProfileImage = ""
    @objc dynamic var likes = 0
}

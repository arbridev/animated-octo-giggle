//
//  UserPhotos.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/25/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import Foundation

// MARK: - UserPhoto
struct UserPhoto: Codable {
    let id: String
    let createdAt, updatedAt: Date
    let width, height: Int
    let color, blurHash: String
    let likes: Int
    let likedByUser: Bool
    let userPhotoDescription: String
    let user: User
    let currentUserCollections: [CurrentUserCollection]
    let urls: Urls
    let links: UserPhotoLinks

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width, height, color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case userPhotoDescription = "description"
        case user
        case currentUserCollections = "current_user_collections"
        case urls, links
    }
}

// MARK: - CurrentUserCollection
struct CurrentUserCollection: Codable {
    let id: Int
    let title: String
    let publishedAt, lastCollectedAt, updatedAt: Date
    let coverPhoto, user: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, title
        case publishedAt = "published_at"
        case lastCollectedAt = "last_collected_at"
        case updatedAt = "updated_at"
        case coverPhoto = "cover_photo"
        case user
    }
}

// MARK: - UserPhotoLinks
struct UserPhotoLinks: Codable {
    let linksSelf, html, download, downloadLocation: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
        case downloadLocation = "download_location"
    }
}

typealias UserPhotos = [UserPhoto]

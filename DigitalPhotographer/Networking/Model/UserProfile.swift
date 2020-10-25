//
//  UserProfile.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/25/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import Foundation

// MARK: - UserProfile
struct UserProfile: Codable {
    let id: String
    let updatedAt: String
    let username, name: String?
    let firstName, lastName: String?
    let instagramUsername, twitterUsername: String
//    let portfolioURL: JSONNull?
    let portfolioURL: String?
    let bio, location: String?
    let totalLikes, totalPhotos, totalCollections: Int
    let followedByUser: Bool
    let followersCount, followingCount, downloads: Int
    let profileImage: ProfileImage
    let badge: Badge?
    let links: Links

    enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case instagramUsername = "instagram_username"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case bio, location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case followedByUser = "followed_by_user"
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case downloads
        case profileImage = "profile_image"
        case badge, links
    }
}

// MARK: - Badge
struct Badge: Codable {
    let title: String
    let primary: Bool
    let slug: String?
    let link: String?
}

// MARK: - Links
struct Links: Codable {
    let linksSelf, html, photos, likes: String
    let portfolio: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio
    }
}

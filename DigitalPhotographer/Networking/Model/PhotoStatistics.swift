//
//  PhotoStatistics.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/25/20.
//  Copyright © 2020 arbridev. All rights reserved.
//
import Foundation

// MARK: - PhotoStatistics
struct PhotoStatistics: Codable {
    let id: String
    let downloads, views, likes: Section
}

// MARK: - Section
struct Section: Codable {
    let total: Int
    let historical: Historical
}

// MARK: - Historical
struct Historical: Codable {
    let change: Int
    let resolution: String
    let quantity: Int
    let values: [Value]
}

// MARK: - Value
struct Value: Codable {
    let date: String
    let value: Int
}

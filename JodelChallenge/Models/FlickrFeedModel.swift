//
//  FlickrFeedModel.swift
//  JodelChallenge
//
//  Created by Ghulam Mustafa on 25/05/2021.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation

struct FlickrFeedModel: Decodable {
    let photos: PhotosModel
}

struct PhotosModel: Decodable {
    let photo: [PhotoList]
    let pages: Int
}

struct PhotoList: Decodable {
    let id: String
    let title: String
    let secret: String
    let server: String
    let farm: Int
}


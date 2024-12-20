//
//  GalleryModel.swift
//  PruebaListaso
//
//  Created by Rene B on 12/19/24.
//

import Foundation

struct GalleryElement: Codable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}

typealias Gallery = [GalleryElement]

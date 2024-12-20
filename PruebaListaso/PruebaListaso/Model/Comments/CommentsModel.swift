//
//  CommentsModel.swift
//  PruebaListaso
//
//  Created by Rene B on 12/19/24.
//

import Foundation

struct Comment: Codable {
    let postID, id: Int
    let name, email, body: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id, name, email, body
    }
}

typealias Comments = [Comment]

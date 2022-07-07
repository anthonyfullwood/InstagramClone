//
//  Post.swift
//  Instagram Clone
//
//  Created by Anthony Fullwood on 14/03/1401 AP.
//

import Foundation
struct Post{
    let id: String
    let postUserId: String
    let username: String
    var caption: String = ""
    let postPhotoUrl: String
    var userLikedPost = false
    var likes: [String] = []
}

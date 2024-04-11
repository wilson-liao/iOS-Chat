//
//  User.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/3/25.
//

import UIKit

struct User: Codable {
    
    var _id: String
    var name: String
    var bio: String
    var img: Data
    
    
    init(name: String, bio: String, img: Data) {
        self._id = ""
        self.name = name
        self.bio = bio
        self.img = img
    }
    
    mutating func setID(id: String) {
        self._id = id
    }
    
    func show() {
        print(self.name)
        print(self.bio)
    }
}

struct login: Codable {
    
    var _id: String
    var userInfoID: String
    var email: String
    var password: String
    
    init(email: String, password: String) {
        self._id = ""
        self.userInfoID = ""
        self.email = email
        self.password = password
    }
    
    mutating func setInfoID(id: String) {
        self.userInfoID = id
    }
    
    mutating func setID(id: String) {
        self._id = id
    }
    
}

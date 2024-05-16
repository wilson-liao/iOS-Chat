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
    var friends: [String]
    var friendRequests: [String]
    var convoEntries: [convoEntry]
    var img: Data
    
    
    init(name: String, bio: String, img: Data) {
        self._id = ""
        self.name = name
        self.bio = bio
        self.img = img
        self.friends = []
        self.friendRequests = []
        self.convoEntries = []
    }
    
    mutating func setID(id: String) {
        self._id = id
    }
    
    func show() {
        print(self.name)
        print(self.bio)
    }
}

struct convoEntry: Codable {
    var friendId: [String]
    var roomId: String
}

struct storeRoomStruct: Codable {
    var roomId: String
    var senderId: String
    var targetId: String
}

struct friendRequestStruct: Codable {
    var targetId: String
    var senderId: String
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

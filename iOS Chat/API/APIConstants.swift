//
//  APIConstants.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/19.
//

import Foundation

let baseURL = "http://localhost:3000"
//let baseURL = "http://192.168.50.74:3000"

// User Info End Points
let getEndPoint = baseURL + "/users"
let postEndPoint = baseURL + "/upload"
let putEndPoint = baseURL + "/user/"

// Friend Request End Points
let frEndPoint = baseURL + "/friendRequest"
let cancelFREndPoint = baseURL + "/cancelFriendRequest"
let addFriendEndPoint = baseURL + "/addFriend"
let rejectFriendEndPoint = baseURL + "/rejectFriend"
let removeFriendEndPoint = baseURL + "/removeFriend"
let getFriendsEndPoint = baseURL + "/getFriendsList"


// Log In End Points
let signup = baseURL + "/signup"
let loginEnd = baseURL + "/login"
let loginPutEnd = baseURL + "/update"
let logoutEnd = baseURL + "/logout"

// Convo End Points
let postConvo = baseURL + "/postConvo"
let getConvo = baseURL + "/getConvo"
let putConvo = baseURL + "/putConvo"

// Room Id End Points
let storeRoomEndPoint = baseURL + "/storeRoomId"

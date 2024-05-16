//
//  ConvoAPI.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/19.
//

import Foundation


func convoPost(c: conversation) async -> Result<String, Error>{
    var id: String = ""
    let url = URL(string: postConvo)!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let data = try! JSONEncoder().encode(c)
    request.httpBody = data
    request.setValue(
        "application/json",
        forHTTPHeaderField: "Content-Type"
    )
    
    do {
        let (data, res) = try await URLSession.shared.data(for: request)
        let statusCode = (res as! HTTPURLResponse).statusCode
        
        if statusCode == 200 {
            print("POST success!")
            id = String(data: data, encoding: .utf8)!
            return .success(id)
        }

        print("POST Request Failed, status code \(statusCode)")
        return .failure(APIError.invalidResponse)
    }
    catch {
        return .failure(error)
    }
}

func getConvo(id:String) async -> Result<conversation, Error> {
    guard let url =  URL(string: getConvo + "/" + id) else {
        print("cannot get URL")
        return .failure(APIError.invalidURL)
    }
    do {
        let (data, res) = try await URLSession.shared.data(from: url)
        let statusCode = (res as! HTTPURLResponse).statusCode
        if statusCode == 200 {
            print("GET Convo success")
            let convo = try JSONDecoder().decode(conversation.self, from: data)
            return .success(convo)
            
        }
        print("GET Request Failed, status code \(statusCode)")
        return .failure(APIError.invalidResponse)
    }
    catch {
        return .failure(error)
    }
}


func putConvo(c: conversation) async -> Result<String, Error>{
    var id = c.roomId
    let urlString = putConvo + "/" + id
    let url = URL(string: urlString)!
    print(urlString)
    
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    
    let data = try! JSONEncoder().encode(c)
    request.httpBody = data
    request.setValue(
        "application/json",
        forHTTPHeaderField: "Content-Type"
    )
    
    do {
        let (data, res) = try await URLSession.shared.data(for: request)
        let statusCode = (res as! HTTPURLResponse).statusCode
        
        if statusCode == 200 {
            print("Update Convo Success!")
            id = String(data: data, encoding: .utf8)!
            return .success(id)
        }
        print("PUT Request Failed, status code \(statusCode)")
        return .failure(APIError.invalidResponse)
    }
    catch {
        return .failure(error)
    }
}

func storeRoomId(roomId: String, user: User, other: User) async -> Result<[User], Error>{
    var id: String = ""
    let url = URL(string: storeRoomEndPoint)!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let dataStruct = storeRoomStruct(roomId: roomId, senderId: user._id, targetId: other._id)
    
    let data = try! JSONEncoder().encode(dataStruct)
    request.httpBody = data
    request.setValue(
        "application/json",
        forHTTPHeaderField: "Content-Type"
    )
    
    do {
        let (data, res) = try await URLSession.shared.data(for: request)
        let statusCode = (res as! HTTPURLResponse).statusCode
        
        if statusCode == 200 {
            print("Store Room Id Success!")
            let users = try JSONDecoder().decode([User].self, from: data)
            return .success(users)
        }

        print("POST Request Failed, status code \(statusCode)")
        return .failure(APIError.invalidResponse)
    }
    catch {
        return .failure(error)
    }
}


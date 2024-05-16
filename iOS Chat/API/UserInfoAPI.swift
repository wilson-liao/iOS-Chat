//
//  API.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/3/26.
//

import Foundation

func getUsers() async -> Result<[User], Error> {
    guard let url =  URL(string: getEndPoint) else {
        print("cannot get URL")
        return .failure(APIError.invalidURL)
    }
    do {
        let (data, res) = try await URLSession.shared.data(from: url)
        let statusCode = (res as! HTTPURLResponse).statusCode
        
        if statusCode == 200 {
            print("Get success!")
            let users = try JSONDecoder().decode([User].self, from: data)
            return .success(users)
        }
        print("GET Request Failed, status code \(statusCode)")
        return .failure(APIError.invalidResponse)
    }
    catch {
        return .failure(error)
    }
}

func getUserByID(id:String) async -> Result<User, Error> {
    guard let url =  URL(string: getEndPoint + "/" + id) else {
        print("cannot get URL")
        return .failure(APIError.invalidURL)
    }
    do {
        let (data, res) = try await URLSession.shared.data(from: url)
        let statusCode = (res as! HTTPURLResponse).statusCode
        if statusCode == 200 {
            let user = try JSONDecoder().decode(User.self, from: data)
            return .success(user)
            
        }
        print("GET Request Failed, status code \(statusCode)")
        return .failure(APIError.invalidResponse)
    }
    catch {
        return .failure(error)
    }
}


func postUser(u: User) async -> Result<String, Error>{
    var id: String = ""
    let url = URL(string: postEndPoint)!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let data = try! JSONEncoder().encode(u)
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

func putUser(u: User) async -> Result<String, Error>{
    var id = u._id
    let urlString = putEndPoint + id
    let url = URL(string: urlString)!
    print(urlString)
    
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    
    let data = try! JSONEncoder().encode(u)
    request.httpBody = data
    request.setValue(
        "application/json",
        forHTTPHeaderField: "Content-Type"
    )
    
    do {
        let (data, res) = try await URLSession.shared.data(for: request)
        let statusCode = (res as! HTTPURLResponse).statusCode
        
        if statusCode == 200 {
            print("PUT success!")
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

func friendRequest(from u1: User, to u2: User) async -> Result<String, Error>{
    var id: String = ""
    let url = URL(string: frEndPoint)!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let frq = friendRequestStruct(targetId: u2._id, senderId: u1._id)
    let data = try! JSONEncoder().encode(frq)
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

func acceptFriendRequest(from u1: User, to u2: User) async -> Result<String, Error>{
    var id: String = ""
    let url = URL(string: addFriendEndPoint)!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let frq = friendRequestStruct(targetId: u2._id, senderId: u1._id)
    let data = try! JSONEncoder().encode(frq)
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


func rejectFriendRequest(from u1: User, to u2: User) async -> Result<String, Error>{
    var id: String = ""
    let url = URL(string: rejectFriendEndPoint)!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let frq = friendRequestStruct(targetId: u2._id, senderId: u1._id)
    let data = try! JSONEncoder().encode(frq)
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

func removeFriend(from u1: User, to u2: User) async -> Result<String, Error>{
    var id: String = ""
    let url = URL(string: removeFriendEndPoint)!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let frq = friendRequestStruct(targetId: u2._id, senderId: u1._id)
    let data = try! JSONEncoder().encode(frq)
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

func getFriendsList(id:String) async -> Result<[User], Error> {
    guard let url =  URL(string: getFriendsEndPoint + "/" + id) else {
        print("cannot get URL")
        return .failure(APIError.invalidURL)
    }
    do {
        let (data, res) = try await URLSession.shared.data(from: url)
        let statusCode = (res as! HTTPURLResponse).statusCode
        if statusCode == 200 {
            print("GET friends success")
            let user = try JSONDecoder().decode([User].self, from: data)
            return .success(user)
            
        }
        print("GET Request Failed, status code \(statusCode)")
        return .failure(APIError.invalidResponse)
    }
    catch {
        return .failure(error)
    }
}


func cancelFR(from u1: User, to u2: User) async -> Result<String, Error>{
    var id: String = ""
    let url = URL(string: cancelFREndPoint)!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let frq = friendRequestStruct(targetId: u2._id, senderId: u1._id)
    let data = try! JSONEncoder().encode(frq)
    request.httpBody = data
    request.setValue(
        "application/json",
        forHTTPHeaderField: "Content-Type"
    )
    
    do {
        let (data, res) = try await URLSession.shared.data(for: request)
        let statusCode = (res as! HTTPURLResponse).statusCode
        print("data: \(data), res: \(res)")
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

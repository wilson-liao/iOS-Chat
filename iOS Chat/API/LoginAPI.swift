//
//  LoginAPI.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/19.
//

import Foundation


// Login Calls
func signUpPost(l: login) async -> Result<String, Error>{
    var id: String = ""
    let url = URL(string: signup)!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let data = try! JSONEncoder().encode(l)
    request.httpBody = data
    request.setValue(
        "application/json",
        forHTTPHeaderField: "Content-Type"
    )
    
    do {
        let (data, res) = try await URLSession.shared.data(for: request)
        let statusCode = (res as! HTTPURLResponse).statusCode
        let resText = String(data: data, encoding: .utf8)!
        
        if statusCode == 200 {
            print("POST success!")
            id = String(data: data, encoding: .utf8)!
            return .success(id)
        }
        if resText.contains("Please enter valid email") {
            return .failure("Please enter valid email")
        }
        if resText.contains("Email account already exists") {
            return .failure("Email account already exists")
        }
        print("POST Request Failed, status code \(statusCode)")
        return .failure(APIError.invalidResponse)
    }
    catch {
        return .failure(error)
    }
}


func loginPut(l: login) async -> Result<String, Error>{
    var id = l._id
    let urlString = loginPutEnd + "/" + id
    let url = URL(string: urlString)!
    print(urlString)
    
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    
    let data = try! JSONEncoder().encode(l)
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


func loginPost(l: login) async -> Result<login, Error> {
//    var id: String = ""
    let url = URL(string: loginEnd)!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let data = try! JSONEncoder().encode(l)
    request.httpBody = data
    request.setValue(
        "application/json",
        forHTTPHeaderField: "Content-Type"
    )
    
    do {
        let (data, res) = try await URLSession.shared.data(for: request)
        let statusCode = (res as! HTTPURLResponse).statusCode
        let resText = String(data: data, encoding: .utf8)!
        
        if statusCode == 200 {
            print("Log In success!")
            let lognEntry = try JSONDecoder().decode(login.self, from: data)
            return .success(lognEntry)
        }
        if resText.contains("Email has not been registered") {
            return .failure("Email has not been registered")
        }
        if resText.contains("Incorrect Password") {
            return .failure("Incorrect Password")
        }
        print("POST Request Failed, status code \(statusCode)")
        return .failure(APIError.invalidResponse)
    }
    catch {
        return .failure(error)
    }
}

func logoutGet(l: login) async -> Result<String, Error>{
    guard let url =  URL(string: logoutEnd) else {
        print("cannot get URL")
        return .failure(APIError.invalidURL)
    }
    do {
        let (data, res) = try await URLSession.shared.data(from: url)
        let statusCode = (res as! HTTPURLResponse).statusCode
        
        if statusCode == 200 {
            print("Log out success!")
            let message = try JSONDecoder().decode(String.self, from: data)
            return .success(message)
        }
        print("GET Request Failed, status code \(statusCode)")
        return .failure(APIError.invalidResponse)
    }
    catch {
        return .failure(error)
    }
}

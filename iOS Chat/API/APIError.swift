//
//  APIError.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/3/26.
//

import Foundation

enum APIError: String, Error {
    case invalidURL = "Invalid URL"
    case invalidResponse = "Invalid Response"
    case invalidData = "Invalid Data"
}

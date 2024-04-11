//
//  StringEXT.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/8.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

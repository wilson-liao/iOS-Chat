//
//  ArrayEXT.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/5/15.
//

import Foundation

func removeUser(u: User, l: inout [User]){
    if let index = l.firstIndex(where: {$0._id == u._id}){
        l.remove(at: index)
    }
}

//
//  SocketHandler.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/18.
//

import Foundation
import SocketIO


class SocketHandler: NSObject {
    
    static let sharedInstance = SocketHandler()
    let socket = SocketManager(socketURL: URL(string: baseURL)!, config: [.log(false), .compress])
    var mSocket: SocketIOClient!
    
    override init() {
        super.init()
        mSocket = socket.defaultSocket
    }
    
    func getSocket() -> SocketIOClient {
        return mSocket
    }
    
    func establishConnection() {
        mSocket.connect()
    }
    
    func closeConnection() {
        mSocket.disconnect()
    }
    
}

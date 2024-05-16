//
//  Messages.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/19.
//

import Foundation
import MessageKit

func defaultConvo(id: String) -> conversation {
    return conversation(roomId: id, messages: [])
}

struct conversation: Codable {
    var roomId: String
    var messages: [dbMessage]
}

struct dbMessage: Codable {
    var sender: Sender
    var messageID: String
    var date: String
    var message: String
    var isRead: Bool
}

//struct Sender: SenderType, Codable {
//    var senderId: String
//    var displayName: String
//}
//
//struct Message: MessageType {
//    var sender: any MessageKit.SenderType
//    var messageId: String
//    var sentDate: Date
//    var kind: MessageKit.MessageKind
//}

let formatter = DateFormatter()


func MessageToDB(m: Message) -> dbMessage {
    // ONLY TEXT RIGHT NOW
    formatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let date = formatter.string(from: m.sentDate)
    
    if case .text(let value) = m.kind {
        let dbM = dbMessage(sender: m.sender as! Sender, messageID: m.messageId, date: date, message: value, isRead: false)
        return dbM
    }
    return dbMessage(sender: m.sender as! Sender, messageID: "-1", date: formatter.string(from: m.sentDate), message: "ERROR", isRead: false)
}

func messagesToDB(ms: [Message]) -> [dbMessage] {
    var msList: [dbMessage] = []
    for m in ms{
        msList.append(MessageToDB(m: m))
    }
    return msList
}

func dbToMessage(dbM: dbMessage) -> Message {
    // ONLY TEXT RIGHT NOW
    formatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    print(dbM.date)
    let date = formatter.date(from:dbM.date)!
    
    let m = Message(sender: dbM.sender, messageId: dbM.messageID, sentDate: date, kind: .text(dbM.message))
    return m
}

func dbToMessages(ms: [dbMessage]) -> [Message] {
    var msList: [Message] = []
    for m in ms{
        msList.append(dbToMessage(dbM: m))
    }
    return msList
}

func getConvoId(user: User, other: User) -> String{
//    print("\n\n\(user)\n\n")
//    print("\n\n\(other)\n\n")
    for convoEntry in user.convoEntries {
//        print("\n\n\(convoEntry.friendId.count == 1)\n\n")
//        print("\n\n\(convoEntry.friendId.contains(other._id))\n\n")
        if convoEntry.friendId.count == 1 && convoEntry.friendId.contains(other._id) {
            return convoEntry.roomId
        }
    }
    return ""
}

func createConvId(user: User, other: User) -> String{
    if (user._id > other._id) {
        return user._id + other._id
    }
    return other._id + user._id
}

//
//  ConversationVC.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/18.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Sender: SenderType, Codable {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: any MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}

class ConversationVC: MessagesViewController {
    
    var user: User!
    var other: User!
    var currentUser: Sender!
    var otherUser: Sender!
    
    var delegate: updateUserDelegate!
    
    var messages: [Message] = []
    var convo: conversation!
    
    let df = DateFormatter()
    let date = Date()
    
    var mSocket = SocketHandler.sharedInstance.getSocket()
    var room: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        self.title = "Conversation"
        self.navigationController?.isNavigationBarHidden = false
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
    
        mSocket.on("receive-message") { (dataArray, ack) -> Void in
            let dataReceived = dataArray[0]
            print("dataArray: \(dataArray)")
            print("dataReceived: \(dataReceived)")
            let newMessage = Message(sender: self.otherUser, messageId: "", sentDate: self.date, kind: .text(dataReceived as! String))
            self.insertNewMessage(newMessage)
        }
    }
    
    init(current: User, other: User, del: updateUserDelegate) {
        super.init(nibName: nil, bundle: nil)
        
        
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        print(self.date)
        print(dateString)
        
        self.delegate = del
        self.user = current
        self.other = other
        self.currentUser = Sender(senderId: current._id, displayName: current.name)
        self.otherUser = Sender(senderId: other._id, displayName: other.name)
        
        joinRoom(current: current, other: other)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func joinRoom(current: User, other: User) {
        self.room = getConvoId(user: user, other: other)
        print(self.room)
        if (self.room == "") {
            self.room = createConvId(user: user, other: other)
            self.convo = defaultConvo(id: self.room)
            Task {
                let res = await storeRoomId(roomId: self.room, user: current, other: other)
                switch res {
                case .success(let users):
                    print("Successfully Stored Room")
                    print(users)
                    self.user = users[0]
                    delegate.updateUser(user: self.user)
                    
                case .failure(let err):
                    print(err)
                }
                // Create Convo
                let convoRes = await convoPost(c: self.convo)
                switch convoRes{
                case.success(_):
                    print("Successfully Started Convo")
                case.failure(let err):
                    print(err)
                }
            }
        }
        else {
            loadConvo(convoId: self.room)
        }
        mSocket.emit("join-room", self.room)
    }
    
    func loadConvo(convoId: String) {
        Task {
            let res = await getConvo(id: convoId)
            switch res {
            case .success(let con):
                print(con)
                self.convo = con
                self.messages = dbToMessages(ms: con.messages)
                messagesCollectionView.reloadData()
            case .failure(let err):
                print(err)
                self.convo = defaultConvo(id: self.room)
            }
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let newMessage = Message(sender: currentUser, messageId: "", sentDate: Date().addingTimeInterval(0), kind: .text(text))
        inputBar.inputTextView.text = ""
        insertNewMessage(newMessage)
        mSocket.emit("send-message", text, self.room)
    }
    

}

extension ConversationVC: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    func insertNewMessage(_ message: Message) {
        messages.append(message)
        messagesCollectionView.reloadData()
        self.convo?.messages = messagesToDB(ms: self.messages)
        uploadConvo()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem(animated: true)
        }
    }
    
    func currentSender() -> any MessageKit.SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func uploadConvo() {
        print(self.convo)
        Task {
            let res = await putConvo(c: self.convo)
            switch res {
            case .success(_):
                print("Upload Convo Success")
            case .failure(let err):
                print(err)
            }
        }
    }
}


//
//  ChatVC.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/3/29.
//

import UIKit

protocol updateUserDelegate {
    func updateUser(user: User)
}

class ChatVC: UIViewController{
    
    
    var table = UITableView()
    
    var selfUser: User!
    var friendsList: [User]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = false
        
        self.title = "Messages"
        configureList()
        
        SocketHandler.sharedInstance.establishConnection()
    }
    
    init(u: User) {
        super.init(nibName: nil, bundle: nil)
        
        self.selfUser = u
        Task {
            let res = await getFriendsList(id: u._id)
            switch res {
            case .success(let users):
                self.friendsList = users
            case.failure(let err):
                print(err)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureList() {
        view.addSubview(table)
        setupTable()
        table.register(ChatListCell.self, forCellReuseIdentifier: "ChatListCell")
        table.rowHeight = 100
        table.pin(to: view)
    }

    func setupTable() {
        table.delegate = self
        table.dataSource = self
    }
    
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource, updateUserDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "ChatListCell") as! ChatListCell
        
        let row = indexPath.row
        cell.set(row: row, friends: self.friendsList)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ConversationVC(current: selfUser, other: friendsList[indexPath.row], del: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateUser(user: User) {
        self.selfUser = user
    }
}

//
//  FriendRequestsVC.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/5/6.
//

import UIKit

class FriendRequestsVC: UIViewController {

    var friendsTB = UITableView()
    var selfUser: User!
    var searchList: [User] = []
    
    var contactsDelegate: friendsTBDelegate?
    var addFriendsDelegate: friendsTBDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = false
        title = "Friend Requests"
        
        Task {
            let res = await getUserByID(id: selfUser._id)
            switch res {
            case .success(let user):
                self.selfUser = user
                
                for id in selfUser.friendRequests {
                    let idres = await getUserByID(id: id)
                    switch idres {
                    case .success(let user):
                        self.searchList.append(user)
                    case.failure(let err):
                        print(err)
                    }
                }
                
                configureList()
                print(self.searchList)
            case.failure(let error):
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    init(user: User, c: friendsTBDelegate, a: friendsTBDelegate) {
        super.init(nibName: nil, bundle: nil)
        
        self.selfUser = user
        self.contactsDelegate = c
        self.addFriendsDelegate = a
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureList() {
        view.addSubview(friendsTB)
        setupTable()
        friendsTB.register(FRCell.self, forCellReuseIdentifier: "FRCell")
        friendsTB.rowHeight = 100
        friendsTB.pin(to: view)
    }

    func setupTable() {
        friendsTB.delegate = self
        friendsTB.dataSource = self
        friendsTB.separatorStyle = .none
    }
}

extension FriendRequestsVC: UITableViewDelegate, UITableViewDataSource, FRCellDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTB.dequeueReusableCell(withIdentifier: "FRCell") as! FRCell
        //        cell.accessoryType = .disclosureIndicator
        
        let row = indexPath.row
        cell.delegate = self
        cell.set(row: row, users: searchList)
        cell.selectionStyle = .none
        cell.acceptButton.tag = indexPath.row
        return cell
    }
    
    func accepted(friend: User) {
        print("accepted")
        Task{
            let res = await acceptFriendRequest(from: self.selfUser, to: friend)
            switch res {
            case.success:
                print("accept success")
                removeUser(u: friend, l: &self.searchList)
                self.friendsTB.reloadData()
                self.contactsDelegate?.reloadTable()
                self.addFriendsDelegate?.reloadTable()
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func rejected(friend: User) {
        print("rejected")
        Task{
            let res = await rejectFriendRequest(from: self.selfUser, to: friend)
            switch res {
            case.success:
                print("reject success")
                removeUser(u: friend, l: &self.searchList)
                self.friendsTB.reloadData()
                self.contactsDelegate?.reloadTable()
                self.addFriendsDelegate?.reloadTable()
            case .failure(let err):
                print(err)
            }
        }
    }
    
}

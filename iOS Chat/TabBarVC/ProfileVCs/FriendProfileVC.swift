//
//  FriendProfileVC.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/22.
//

import UIKit

enum friendStatus {
    case isFriend
    case notFriend
    case sentRequest
}

class FriendProfileVC: UIViewController {

    var pfpimg: ProfilePic!
    var userNameLabel = UILabel()
    var notelabel = UILabel()
    var noteField = UITextView()
    var addRemoveButton = UIButton()
    
    var contactsDelegate: friendsTBDelegate!
    var addFriendsDelegate: friendsTBDelegate!
    var fStatus: friendStatus = .notFriend
    var selfUser: User!
    var friend: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        self.title = "User Information"
        
        configureImg()
        configureName()
        configureNoteLabel()
        configureNoteField()
        configureAddRemoveButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    init(selfUser: User, friend: User, contactsDelegate: friendsTBDelegate, addFriendsDelegate: friendsTBDelegate) {
        super.init(nibName: nil, bundle: nil)
        
        self.selfUser = selfUser
        self.friend = friend
        self.contactsDelegate = contactsDelegate
        self.addFriendsDelegate = addFriendsDelegate
        
        if (selfUser.friends.contains(self.friend._id)) {
            self.fStatus = .isFriend
        }
        else if (self.friend.friendRequests.contains(self.selfUser._id)) {
            self.fStatus = .sentRequest
        }
        else {
            self.fStatus = .notFriend
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImg() {
        let height = 130.0
        let width = 130.0
        
        pfpimg = ProfilePic(img: UIImage(data: self.friend.img)!)
        view.addSubview(pfpimg)
        pfpimg.translatesAutoresizingMaskIntoConstraints = false
        
        pfpimg.bounds = CGRect(x: pfpimg.bounds.origin.x, y: pfpimg.bounds.origin.y, width: width, height: height)
        
        NSLayoutConstraint.activate([
            pfpimg.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            pfpimg.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            pfpimg.widthAnchor.constraint(equalToConstant: width),
            pfpimg.heightAnchor.constraint(equalToConstant: height)
        ])
        
        pfpimg.setupHexagonMask(lineWidth: 5, color: .gray, cornerRadius: 0)
    }
    
    func configureName() {
        view.addSubview(userNameLabel)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userNameLabel.text = self.friend.name
        userNameLabel.font = UIFont(name: "systemFont", size: 30)
        
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: pfpimg.trailingAnchor, constant: 20),
            userNameLabel.centerYAnchor.constraint(equalTo: pfpimg.centerYAnchor, constant: -20)
        ])
        
    }
    
    func configureNoteLabel() {
        view.addSubview(notelabel)
        notelabel.translatesAutoresizingMaskIntoConstraints = false
        
        notelabel.text = "Note:"
        
        NSLayoutConstraint.activate([
            notelabel.topAnchor.constraint(equalTo: pfpimg.bottomAnchor, constant: 30),
            notelabel.leadingAnchor.constraint(equalTo: pfpimg.leadingAnchor)
        ])
    }
    
    func configureNoteField() {
        view.addSubview(noteField)
        noteField.translatesAutoresizingMaskIntoConstraints = false
        
        noteField.backgroundColor = .lightGray
        
        NSLayoutConstraint.activate([
            noteField.topAnchor.constraint(equalTo: notelabel.bottomAnchor, constant: 15),
            noteField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            noteField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            noteField.heightAnchor.constraint(equalToConstant: 150)
        ])
        
    }
    
    func configureAddRemoveButton() {
        let addTitle: String
        switch self.fStatus {
        case .isFriend:
            addTitle = "Remove Friend"
        case .notFriend:
            addTitle = "Add Friend"
        case .sentRequest:
            addTitle = "Cancel Friend Request"
        }
        
        view.addSubview(addRemoveButton)
        addRemoveButton.translatesAutoresizingMaskIntoConstraints = false
        
        addRemoveButton.backgroundColor = .lightGray
        addRemoveButton.setTitleColor(.black, for: .normal)
        addRemoveButton.titleLabel?.font = UIFont(name: "systemFont", size: 20)
        addRemoveButton.setTitle(addTitle, for: .normal)
        addRemoveButton.addTarget(self, action: #selector(addRemoveClicked), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            addRemoveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addRemoveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            addRemoveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            addRemoveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
    }
    
    @objc func addRemoveClicked() {
        switch self.fStatus {
        case .isFriend:
            self.fStatus = .notFriend
            addRemoveButton.setTitle("Add Friend", for: .normal)
            Task {
                let res = await removeFriend(from: selfUser, to: friend)
                switch res {
                case .success:
                    print("Successfully removed friend")
                    self.contactsDelegate.reloadTable()
                    self.addFriendsDelegate.reloadTable()
                case.failure(let err):
                    print(err)
                }
            }
        case .notFriend:
            self.fStatus = .sentRequest
            addRemoveButton.setTitle("Cancel Friend Request", for: .normal)
            Task {
                let res = await friendRequest(from: selfUser, to: friend)
                switch res {
                case.success:
                    print("Successfully sent friend request")
                    self.contactsDelegate.reloadTable()
                    self.addFriendsDelegate.reloadTable()
                case.failure(let err):
                    print(err)
                }
            }
        case .sentRequest:
            self.fStatus = .notFriend
            addRemoveButton.setTitle("Add Friend", for: .normal)
            Task {
                let res = await cancelFR(from: selfUser, to: friend)
                switch res {
                case .success:
                    print("Successfully Cancelled Friend Request")
                    self.contactsDelegate.reloadTable()
                    self.addFriendsDelegate.reloadTable()
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
}

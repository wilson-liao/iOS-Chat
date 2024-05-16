//
//  newVC.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/3/29.
//

import UIKit

protocol friendsTBDelegate {
    func reloadTable()
}

class ContactsVC: UIViewController, friendsTBDelegate{
    
    

    var searchBar = UITextField()
    var addFriendButton = UIButton()
    var topArea = UILabel()
    var contactsTable = UITableView()
    
    var config: UIImage.Configuration!
    var selfUser: User!
    var friends: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .systemBackground
        
        self.navigationController?.isNavigationBarHidden = true
        
        config = UIImage.SymbolConfiguration(pointSize: 20)
        
        populateFriendsList()
        configureTopArea()
        configureSearchBar()
        configureAddFriendButton()
        configureList()
    }
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        
        self.selfUser = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadTable() {
        Task {
            let userRes = await getUserByID(id: self.selfUser._id)
            switch userRes {
            case .success(let user):
                self.selfUser = user
            case .failure(let err):
                print(err)
            }
        }
        self.populateFriendsList()
    }
    
    
    func populateFriendsList() {
//        let img = UIImage(named: "pfp")?.PNGData
//        let u = User(name: "test", bio: "", img: img!)
//        self.friends = [u]
        Task {
            let res = await getFriendsList(id: self.selfUser._id)
            switch (res) {
            case.success(let friends):
                self.friends = friends
//                print(self.friends)
                contactsTable.reloadData()
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func configureTopArea() {
        view.addSubview(topArea)
        topArea.translatesAutoresizingMaskIntoConstraints = false
        
        topArea.backgroundColor = .lightGray
        topArea.layer.masksToBounds = true
        topArea.layer.cornerRadius = 15
        
        
        NSLayoutConstraint.activate([
            topArea.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topArea.topAnchor.constraint(equalTo: view.topAnchor),
            topArea.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0),
            topArea.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/7)
        ])
    }
    
    func configureSearchBar() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.placeholder = "  Search Contact"
        searchBar.backgroundColor = .systemBackground
        searchBar.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: topArea.centerYAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: topArea.leadingAnchor, constant: 20),
            searchBar.widthAnchor.constraint(equalTo: topArea.widthAnchor, constant: -90),
            searchBar.heightAnchor.constraint(equalTo: topArea.heightAnchor, multiplier: 1/4)
        ])
    }
    
    func configureAddFriendButton() {
        view.addSubview(addFriendButton)
        addFriendButton.translatesAutoresizingMaskIntoConstraints = false
        
        addFriendButton.configuration = .plain()
        addFriendButton.configuration?.image = UIImage(systemName: "person.crop.circle.fill.badge.plus", withConfiguration: config)
        addFriendButton.tintColor = .white
        addFriendButton.addTarget(self, action: #selector(addClicked), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addFriendButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            addFriendButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 15),
            addFriendButton.heightAnchor.constraint(equalTo: searchBar.heightAnchor),
            addFriendButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    func configureList() {
        view.addSubview(contactsTable)
        setupTable()
        contactsTable.register(ContactsListCell.self, forCellReuseIdentifier: "ContactsListCell")
        contactsTable.rowHeight = 100
        
        contactsTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contactsTable.topAnchor.constraint(equalTo: topArea.bottomAnchor, constant: 10),
            contactsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contactsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contactsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupTable() {
        contactsTable.delegate = self
        contactsTable.dataSource = self
        contactsTable.separatorStyle = .none
    }
    
    @objc func addClicked() {
        let vc = AddFriendsVC(user: self.selfUser, contactsVC: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

}

extension ContactsVC: UITableViewDelegate, UITableViewDataSource, updateUserDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsTable.dequeueReusableCell(withIdentifier: "ContactsListCell") as! ContactsListCell
        let row = indexPath.row
        cell.set(row: row, users: self.friends)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ConversationVC(current: selfUser, other: friends[indexPath.row], del: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateUser(user: User) {
        self.selfUser = user
    }
    
}


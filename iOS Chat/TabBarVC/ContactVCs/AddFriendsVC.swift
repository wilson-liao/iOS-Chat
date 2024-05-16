//
//  AddFriendsVC.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/22.
//

import UIKit

class AddFriendsVC: UIViewController {
    
    

    var topArea = UILabel()
    var searchBar = UITextField()
    var searchButton = UIButton()
    var frButton = UIButton()
    var friendsTB = UITableView()
    var selfUser: User!
    var searchList: [User]!
    
    var contactsVC: friendsTBDelegate!
    
    var config: UIImage.Configuration!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = false
        title = "Add Friends"
        
        config = UIImage.SymbolConfiguration(pointSize: 20)
        
        configureTopArea()
        configureSearchBar()
        configurefrButton()
        
        Task {
            let res = await getUsers()
            switch res {
            case .success(let users):
                self.searchList = users
                configureList()
//                print(self.searchList)
            case.failure(let error):
                print(error)
            }
        }
    }
    
    init(user: User, contactsVC: friendsTBDelegate) {
        super.init(nibName: nil, bundle: nil)
        
        self.selfUser = user
        self.contactsVC = contactsVC
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureList() {
        view.addSubview(friendsTB)
        setupTable()
        friendsTB.register(ContactsListCell.self, forCellReuseIdentifier: "ContactsListCell")
        friendsTB.rowHeight = 100
        
        friendsTB.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            friendsTB.topAnchor.constraint(equalTo: topArea.bottomAnchor, constant: 10),
            friendsTB.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            friendsTB.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            friendsTB.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupTable() {
        friendsTB.delegate = self
        friendsTB.dataSource = self
        friendsTB.separatorStyle = .none
    }

    func configureTopArea() {
        view.addSubview(topArea)
        topArea.translatesAutoresizingMaskIntoConstraints = false
        
        topArea.backgroundColor = .lightGray
        topArea.layer.masksToBounds = true
        topArea.layer.cornerRadius = 15
        
        
        NSLayoutConstraint.activate([
            topArea.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topArea.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0),
            topArea.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/10)
        ])
    }
    
    func configureSearchBar() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBar.placeholder = "  Search"
        searchBar.backgroundColor = .systemBackground
        searchBar.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: topArea.centerYAnchor, constant: 0),
            searchBar.leadingAnchor.constraint(equalTo: topArea.leadingAnchor, constant: 20),
            searchBar.widthAnchor.constraint(equalTo: topArea.widthAnchor, constant: -140),
            searchBar.heightAnchor.constraint(equalTo: topArea.heightAnchor, multiplier: 1/4)
        ])
    }
    
    func configurefrButton() {
        view.addSubview(frButton)
        frButton.translatesAutoresizingMaskIntoConstraints = false
        
        frButton.configuration = .plain()
        frButton.configuration?.image = UIImage(systemName: "person.crop.circle.fill.badge.plus", withConfiguration: config)
        frButton.configuration?.title = "Requests"
        frButton.tintColor = .white
        frButton.addTarget(self, action: #selector(frClicked), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            frButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            frButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 45),
            frButton.heightAnchor.constraint(equalTo: searchBar.heightAnchor),
            frButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func frClicked() {
        let vc = FriendRequestsVC(user: selfUser, c: self.contactsVC, a: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}




extension AddFriendsVC: UITableViewDelegate, UITableViewDataSource, friendsTBDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTB.dequeueReusableCell(withIdentifier: "ContactsListCell") as! ContactsListCell
        let row = indexPath.row
        cell.set(row: row, users: searchList)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = self.searchList[indexPath.row]
        let vc = FriendProfileVC(selfUser: self.selfUser, friend: friend, contactsDelegate: self.contactsVC, addFriendsDelegate: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func reloadTable() {
        Task {
//            let res = await getUsers()
//            switch res {
//            case .success(let users):
//                self.searchList = users
//                configureList()
//            case.failure(let error):
//                print(error)
//            }
            let userRes = await getUserByID(id: self.selfUser._id)
            switch userRes {
            case .success(let user):
                self.selfUser = user
            case .failure(let err):
                print(err)
            }
        }
    }
}

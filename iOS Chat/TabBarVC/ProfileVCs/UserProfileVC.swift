//
//  UserProfileVC.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/3/25.
//

import UIKit
import Photos
import PhotosUI

class UserProfileVC: UIViewController {

    var nameLabel = UILabel()
    var imageLabel = UIImageView()
    var editButton = UIButton()
    var logoutButton = UIButton()
    
    var userList: [User]!
    var user: User!
    var loginEntry: login!
    var config: UIImage.Configuration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        self.navigationController?.isNavigationBarHidden = true
        
        config = UIImage.SymbolConfiguration(pointSize: 20)
        
        configureImage()
        configureName()
        configureEdit()
        configureLogout()
        configInit()
    }
    
    init(user: User, entry: login) {
        super.init(nibName: nil, bundle: nil)
        
        self.user = user
        self.loginEntry = entry
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configInit() {
        nameLabel.text = self.user.name
        imageLabel.image = UIImage(data: self.user.img)
    }
    
    func configureName() {
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = "User"
        nameLabel.font = UIFont(name: "systemFont", size: 30)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageLabel.bottomAnchor, constant: 30),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureImage() {
        view.addSubview(imageLabel)
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageLabel.image = UIImage(named: "pfp")

        NSLayoutConstraint.activate([
            imageLabel.widthAnchor.constraint(equalToConstant: 150),
            imageLabel.heightAnchor.constraint(equalToConstant: 150),
            imageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
        
    }
    
    func configureEdit() {
        view.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        editButton.configuration = .plain()
        editButton.configuration?.image = UIImage(systemName: "highlighter", withConfiguration: config)
        editButton.tintColor = .black
        editButton.addTarget(self, action: #selector(editClicked), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            editButton.widthAnchor.constraint(equalToConstant: 80),
            editButton.heightAnchor.constraint(equalToConstant: 80),
            editButton.centerYAnchor.constraint(equalTo: imageLabel.topAnchor),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func editClicked() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        let editVC = EditProfileVC(user: self.user, loginEntry: self.loginEntry)
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func configureLogout() {
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        logoutButton.backgroundColor = .red
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutClicked), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            logoutButton.widthAnchor.constraint(equalToConstant: 100),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func logoutClicked() {
        
        Task{
            let res = await logoutGet(l: self.loginEntry)
            switch res {
            case .success(let message):
                print(message)
                let vc = LogInVC()
                let window = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
                window?.rootViewController = UINavigationController(rootViewController: vc)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}


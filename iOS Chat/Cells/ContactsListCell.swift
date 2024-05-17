//
//  ContactsListCell.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/19.
//

import UIKit

class ContactsListCell: UITableViewCell {
    
    var container = UIView()
    
    var userimg = UIImageView()
    var userName = UILabel()
    var userList: [User]!
    var row: Int!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureContainer()
        configureImg()
        configureTitle()
        setImgConstraints()
        setTitleConstraints()
        
        self.selectionStyle = .gray
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContainer() {
        addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .systemMint
        container.layer.cornerRadius = 10
        
        container.layoutMargins = UIEdgeInsets(top: 15, left: 17, bottom: 15, right: 17) // It isn't really necessary unless you've got an extremely complex table view cell. Otherwise, you could just write e.g. containerView.topAnchor
        
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
}
    
    func set(row: Int, users:[User]){
        self.row = row
        userName.text = "test user \(self.row!)"
        userName.text = users[row].name
        userimg.image = UIImage(data: users[row].img)
    }
    
    func configureImg() {
        container.addSubview(userimg)
        userimg.image = UIImage(named: "pfp")
        userimg.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        userimg.contentMode = . scaleAspectFill
    }
    
    func configureTitle() {
        container.addSubview(userName)
        userName.numberOfLines = 0
        userName.adjustsFontSizeToFitWidth = true
        userName.font = UIFont.boldSystemFont(ofSize: 25)
    }
    
    func setImgConstraints() {
        userimg.translatesAutoresizingMaskIntoConstraints = false
        userimg.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        userimg.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 30).isActive = true
        userimg.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userimg.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userimg.layer.cornerRadius = userimg.frame.width / 2
        userimg.clipsToBounds = true
    }
    
    func setTitleConstraints() {
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.centerYAnchor.constraint(equalTo: userimg.centerYAnchor).isActive = true
        userName.leadingAnchor.constraint(equalTo: userimg.trailingAnchor, constant: 25).isActive = true
    }
    
}

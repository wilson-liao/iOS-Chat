//
//  ChatListCell.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/18.
//

import UIKit

class ChatListCell: UITableViewCell {
    
    var userimg = UIImageView()
    var userName = UILabel()
    var userText = UILabel()
    
    var row: Int!
    var friends: [User]!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureImg()
        configureTitle()
        configureText()
        setImgConstraints()
        setTitleConstraints()
        setTextConstraints()
        
        self.selectionStyle = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(row: Int, friends: [User]){
        self.row = row
        self.friends = friends
        userName.text = friends[row].name
        userText.text = "sample text"
    }
    
    func configureImg() {
        addSubview(userimg)
        userimg.image = UIImage(named: "pfp")
        userimg.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        userimg.contentMode = . scaleAspectFill
    }
    
    func configureTitle() {
        addSubview(userName)
        userName.numberOfLines = 0
        userName.adjustsFontSizeToFitWidth = true
        userName.font = UIFont.boldSystemFont(ofSize: 25)
    }
    
    func configureText() {
        addSubview(userText)
        userText.numberOfLines = 0
        userText.adjustsFontSizeToFitWidth = true
        userText.font = UIFont(name: "systemFont", size: 20)
    }
    
    func setImgConstraints() {
        userimg.translatesAutoresizingMaskIntoConstraints = false
        userimg.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        userimg.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        userimg.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userimg.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userimg.layer.cornerRadius = userimg.frame.width / 2
        userimg.clipsToBounds = true
    }
    
    func setTitleConstraints() {
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.centerYAnchor.constraint(equalTo: userimg.topAnchor, constant: 10).isActive = true
        userName.leadingAnchor.constraint(equalTo: userimg.trailingAnchor, constant: 25).isActive = true
//        userName.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        userName.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2).isActive = true
    }
    
    func setTextConstraints() {
        userText.translatesAutoresizingMaskIntoConstraints = false
        userText.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 0).isActive = true
        userText.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        userText.leadingAnchor.constraint(equalTo: userName.leadingAnchor).isActive = true
    }
    
}


//
//  ContactsListCell.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/19.
//

import UIKit

protocol FRCellDelegate {
    func accepted(friend: User)
    func rejected(friend: User)
}

class FRCell: UITableViewCell {
    
    var container = UIView()
    
    var acceptButton = UIButton()
    var rejectButton = UIButton()
    
    var config: UIImage.Configuration!
    
    var userimg = UIImageView()
    var userName = UILabel()
    var friend: User!
    var row: Int!
    
    var delegate: FRCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        config = UIImage.SymbolConfiguration(pointSize: 20)
        
        configureContainer()
        configureImg()
        configureTitle()
        setImgConstraints()
        setTitleConstraints()
        configureReject()
        configureAccept()
        
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
        self.friend = users[row]
        userName.text = "test user \(row)"
        userName.text = self.friend.name
        print("\(row), \(users[row])")
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
    
    func configureReject() {
        contentView.addSubview(rejectButton)
        
        rejectButton.configuration = .plain()
        rejectButton.configuration?.image = UIImage(systemName: "xmark", withConfiguration: config)
        rejectButton.tintColor = .white
        rejectButton.addTarget(self, action: #selector(rejectClicked), for: .touchUpInside)
        
        rejectButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rejectButton.leadingAnchor.constraint(equalTo: container.trailingAnchor, constant: -90),
            rejectButton.centerYAnchor.constraint(equalTo: userimg.centerYAnchor),
            rejectButton.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func configureAccept() {
        contentView.addSubview(acceptButton)
        
        acceptButton.configuration = .plain()
        acceptButton.configuration?.image = UIImage(systemName: "checkmark", withConfiguration: config)
        acceptButton.tintColor = .white
        acceptButton.addTarget(self, action: #selector(acceptClicked), for: .touchUpInside)
        
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            acceptButton.leadingAnchor.constraint(equalTo: rejectButton.trailingAnchor, constant: 10),
            acceptButton.centerYAnchor.constraint(equalTo: userName.centerYAnchor),
        ])
    }
    
    @objc func rejectClicked() {
        self.acceptButton.isEnabled = false
        self.rejectButton.isEnabled = false
        delegate?.rejected(friend: self.friend)
    }
    
    @objc func acceptClicked() {
        self.acceptButton.isEnabled = false
        self.rejectButton.isEnabled = false
        delegate?.accepted(friend: self.friend)
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
        userName.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
}

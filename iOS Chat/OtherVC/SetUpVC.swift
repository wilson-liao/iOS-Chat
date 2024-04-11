//
//  SetUpVC.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/8.
//

import UIKit

class SetUpVC: UIViewController {

    let userNameField = UITextField()
    let bioField = UITextView()
    let imgView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    
    func configureUI() {
        configUserName()
        configBio()
        configImg()
    }
    
    func configUserName() {
        view.addSubview(userNameField)
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        
        userNameField.placeholder = ""
    }
    
    func configBio() {
        
    }
    
    func configImg() {
        
    }

}

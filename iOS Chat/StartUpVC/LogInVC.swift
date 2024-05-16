//
//  LogInVC.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/3/30.
//

import UIKit
import CryptoKit

class LogInVC: UIViewController {
    
    var titleLabel = UILabel()
    var userNameField = UITextField()
    var passwordField = UITextField()
    var loginButton = UIButton()
    var signupButton = UIButton()
    
    var loginEntry: login!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = true
        
        configureUI()
    }
    
    func configureUI() {
        configureTitle()
        configureUserName()
        configurePassword()
        configureLoginButton()
        configureSignUpButton()
    }
    
    func configureTitle() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textAlignment = .center
        titleLabel.text = "Log In"
        titleLabel.font = UIFont(name: "systemFont", size: 30)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 150),
            titleLabel.heightAnchor.constraint(equalToConstant: 70),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 170)
        ])
    }
    
    func configureUserName() {
        view.addSubview(userNameField)
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        
        userNameField.placeholder = "Enter User Name"
        userNameField.font = UIFont(name: "systemFont", size: 15)
        userNameField.textColor = .black
        userNameField.delegate = self
        userNameField.returnKeyType = .done
        userNameField.borderStyle = .roundedRect
        userNameField.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            userNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameField.widthAnchor.constraint(equalToConstant: 200),
            userNameField.heightAnchor.constraint(equalToConstant: 50),
            userNameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30)
        ])
    }
    
    func configurePassword() {
        view.addSubview(passwordField)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordField.placeholder = "Enter Password"
        passwordField.font = UIFont(name: "systemFont", size: 15)
        passwordField.textColor = .black
        passwordField.delegate = self
        passwordField.returnKeyType = .done
        passwordField.borderStyle = .line
        userNameField.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.widthAnchor.constraint(equalToConstant: 200),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            passwordField.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 30)
        ])
    }
    
    func configureLoginButton() {
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = .opaqueSeparator
        loginButton.addTarget(self, action: #selector(loginClicked), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: passwordField.centerXAnchor, constant: 15),
            loginButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor)
        ])
    }
    
    @objc func loginClicked() {
        userNameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        // Log in authentication
        if userNameField.text == "" {
            print("Enter Valid Email")
        }
        if passwordField.text == "" {
            print("Enter valid Password")
        }
        let userName = userNameField.text ?? ""
        let passWord = passwordField.text ?? ""
//        let data = passWord.data(using: .utf8)!
        
        self.loginEntry = login(email: userName, password: passWord)
        // not authenticated -> Re-enter credentials
        Task {
            let res = await loginPost(l:self.loginEntry)
            switch res {
            case.success(let entry):
                // authenticated
                self.loginEntry = entry

                // get user info from server
                let res = await getUserByID(id: self.loginEntry.userInfoID)
                switch res {
                case.success(let user):
                    // Take user to Tab Bar view
                    let user = user
                    let vc = TBController(user:user, loginEntry: self.loginEntry)
                    self.navigationController?.viewControllers = [vc]
                case.failure(let error):
                    print(error)
                }
                
            case.failure(let error):
                print(error)
            }
        }
    }
    
    
    func configureSignUpButton() {
        view.addSubview(signupButton)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.backgroundColor = .opaqueSeparator
        signupButton.addTarget(self, action: #selector(signUpClicked), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            signupButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            signupButton.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor),
            signupButton.trailingAnchor.constraint(equalTo: passwordField.centerXAnchor, constant: -15)
        ])
    }
    
    @objc func signUpClicked() {
        let vc = SignUpVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension LogInVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ titleText: UITextField) -> Bool {
        titleText.resignFirstResponder()
        return true
    }
}


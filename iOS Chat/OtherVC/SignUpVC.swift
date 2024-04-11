//
//  SignUpVC.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/3.
//

import UIKit
import CryptoKit

class SignUpVC: UIViewController {
    
    var titleLabel = UILabel()
    var userNameField = UITextField()
    var passwordField = UITextField()
    var confirmPassword = UITextField()
    var signupButton = UIButton()
    var emailErrorLabel = UILabel()
    var passwordErrorLabel = UILabel()
    var conpasswordErrorLabel = UILabel()
    
    var loginEntry: login!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureUI()
    }
    
    func configureUI() {
        configureTitle()
        configureUserName()
        configureEmailError()
        configurePassword()
        configurePassError()
        configureConfirmPassword()
        configureConPassError()
        configureSignUpButton()
       
    }
    
    func configureTitle() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textAlignment = .center
        titleLabel.text = "Sign Up"
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
        
        userNameField.placeholder = "Enter Email"
        userNameField.font = UIFont(name: "systemFont", size: 15)
        userNameField.delegate = self
        userNameField.returnKeyType = .done
        userNameField.borderStyle = .roundedRect
        userNameField.layer.borderWidth = 1
        userNameField.clearButtonMode = .whileEditing
        
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
        passwordField.delegate = self
        passwordField.returnKeyType = .done
        passwordField.borderStyle = .line
        passwordField.layer.borderWidth = 1
        passwordField.clearButtonMode = .whileEditing
        
        NSLayoutConstraint.activate([
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.widthAnchor.constraint(equalToConstant: 200),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            passwordField.topAnchor.constraint(equalTo: emailErrorLabel.bottomAnchor, constant: 30)
        ])
    }
    
    func configureConfirmPassword() {
        view.addSubview(confirmPassword)
        confirmPassword.translatesAutoresizingMaskIntoConstraints = false
        
        confirmPassword.placeholder = "Re-enter Password"
        confirmPassword.font = UIFont(name: "systemFont", size: 15)
        confirmPassword.delegate = self
        confirmPassword.returnKeyType = .done
        confirmPassword.borderStyle = .line
        confirmPassword.layer.borderWidth = 1
        confirmPassword.clearButtonMode = .whileEditing
        
        NSLayoutConstraint.activate([
            confirmPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPassword.widthAnchor.constraint(equalToConstant: 200),
            confirmPassword.heightAnchor.constraint(equalToConstant: 50),
            confirmPassword.topAnchor.constraint(equalTo: passwordErrorLabel.bottomAnchor, constant: 30)
        ])
    }
    
    
    func configureSignUpButton() {
        view.addSubview(signupButton)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.backgroundColor = .opaqueSeparator
        signupButton.addTarget(self, action: #selector(signUpClicked), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            signupButton.topAnchor.constraint(equalTo: conpasswordErrorLabel.bottomAnchor, constant: 30),
            signupButton.leadingAnchor.constraint(equalTo: conpasswordErrorLabel.leadingAnchor),
            signupButton.trailingAnchor.constraint(equalTo: conpasswordErrorLabel.trailingAnchor),
            signupButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func configureEmailError() {
        view.addSubview(emailErrorLabel)
        emailErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailErrorLabel.textColor = .red
        emailErrorLabel.textAlignment = .center
        emailErrorLabel.text = ""
        emailErrorLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            emailErrorLabel.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 30),
            emailErrorLabel.leadingAnchor.constraint(equalTo: userNameField.leadingAnchor),
            emailErrorLabel.trailingAnchor.constraint(equalTo: userNameField.trailingAnchor)
        ])
    }
    
    func configurePassError() {
        view.addSubview(passwordErrorLabel)
        passwordErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        passwordErrorLabel.textColor = .red
        passwordErrorLabel.textAlignment = .center
        passwordErrorLabel.text = ""
        passwordErrorLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            passwordErrorLabel.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            passwordErrorLabel.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor),
            passwordErrorLabel.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor)
        ])
    }
    
    func configureConPassError() {
        view.addSubview(conpasswordErrorLabel)
        conpasswordErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        conpasswordErrorLabel.textColor = .red
        conpasswordErrorLabel.textAlignment = .center
        conpasswordErrorLabel.text = ""
        conpasswordErrorLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            conpasswordErrorLabel.topAnchor.constraint(equalTo: confirmPassword.bottomAnchor, constant: 30),
            conpasswordErrorLabel.leadingAnchor.constraint(equalTo: confirmPassword.leadingAnchor),
            conpasswordErrorLabel.trailingAnchor.constraint(equalTo: confirmPassword.trailingAnchor)
        ])
    }
    @objc func signUpClicked() {
        if checkCred() {
            Task {
                let flag = await registerUser()
                if flag {
                    print("go set up")
                    goToSetUp()
                }
            }
        }
    }
    
    func checkCred() -> Bool {
        let userName = userNameField.text!
        var flag = true
        if (userName == "") {
            print("Enter Email")
            emailErrorLabel.text = "Enter Email\n"
            flag = false
        }
        else {
            emailErrorLabel.text = ""
        }
        
        if passwordField.text != confirmPassword.text {
            print("Passwords don't match. Re-enter passwords")
            conpasswordErrorLabel.text = "Passwords don't match. Re-enter passwords\n"
            flag = false
        }
        else {
            conpasswordErrorLabel.text = ""
        }
        if passwordField.text == "" {
            print("Enter Password")
            passwordErrorLabel.text = "Enter Password\n"
            flag = false
        }
        else {
            passwordErrorLabel.text = ""
        }
        return flag
    }
    
    func registerUser() async -> Bool{
        
        
        let flag = Task {
            let email = userNameField.text!
            guard let password = passwordField.text else {
                print("ENTER PASSWORD")
                return false
            }
            
            self.loginEntry = login(email: email, password: password)
            let res = await signUpPost(l: self.loginEntry)
            switch res {
            case.success(let id):
                let parsedID = String(Array(id)[1..<id.count-1])
                self.loginEntry.setID(id: parsedID)
                print("log in entry id: \(self.loginEntry._id)")
                return true
            case.failure(let error):
                if (error.localizedDescription == "Please enter valid email") {
                    emailErrorLabel.text = "Please enter valid email"
                }
                if (error.localizedDescription == "Email account already exists") {
                    emailErrorLabel.text = "Email account already exists"
                }
                return false
            }
        }
        return await flag.value
    }
    
    func goToSetUp() {
        let data = UIImage(named: "pfp")?.PNGData
        let user = User(name: "Enter User Name", bio: "", img: data!)
        let vc = EditProfileVC(user:user, loginEntry: self.loginEntry)
        self.navigationController?.viewControllers = [vc]
    }
}

extension SignUpVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ titleText: UITextField) -> Bool {
        titleText.resignFirstResponder()
        return true
    }
}


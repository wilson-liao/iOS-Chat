//
//  EditProfileVC.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/3/29.
//

import UIKit
import PhotosUI

class EditProfileVC: UIViewController{

    var nameLabel = UILabel()
    var nameField = UITextField()
    var bioLabel = UILabel()
    var bioButton = UIButton()
    var imageLabel = UIImageView()
    var saveButton = UIButton()
    var uploadButton = UIButton()
    
    
    var user: User!
    var loginEntry: login!
    
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureImage()
        configureName()
    }
    
    init(user: User, loginEntry: login){
        super.init(nibName: nil, bundle: nil)
        
        self.user = user
        self.loginEntry = loginEntry
        configureImage()
        configureName()
        configureUpload()
        configureSave()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureName() {
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = "Name"
        nameLabel.font = UIFont(name: "systemFont", size: 25)
        nameLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageLabel.bottomAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
//        var frame: CGRect = nameLabel.frame
//        frame.size.height = 100
//        nameLabel.frame = frame
        
        view.addSubview(nameField)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        
        nameField.placeholder = self.user.name
        nameField.font = UIFont(name: "systemFont", size: 25)
        nameField.returnKeyType = .done
        nameField.delegate = self
        nameField.clearButtonMode = .whileEditing
//        let border = CALayer()
//        border.frame = CGRect(x: -30, y: -10, width: view.frame.size.width, height: 1)
//        border.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
//        nameLabel.layer.addSublayer(border)
        let borderColor = CGColor(red: 255, green: 0, blue: 0, alpha: 0.3)
        nameLabel.layer.addWaghaBorder(edge: .top, color: borderColor, thickness: 1, width: view.frame.size.width)
        nameLabel.layer.addWaghaBorder(edge: .bottom, color: borderColor, thickness: 1, width: view.frame.size.width)
        
        
        
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: imageLabel.bottomAnchor, constant: 30),
            nameField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 20)
        ])
        
        
    }
    
    func textFieldShouldReturn(_ titleText: UITextField) -> Bool {
        titleText.resignFirstResponder()
        self.user.name = nameField.text ?? nameField.placeholder!
        return true
    }
    
    func configureImage() {
        view.addSubview(imageLabel)
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageLabel.image = UIImage(data: self.user.img)

        
        NSLayoutConstraint.activate([
            imageLabel.widthAnchor.constraint(equalToConstant: 150),
            imageLabel.heightAnchor.constraint(equalToConstant: 150),
            imageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
        
    }
    
    func configureUpload() {
        view.addSubview(uploadButton)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        
        uploadButton.setTitle("Upload", for: .normal)
        uploadButton.addTarget(self, action: #selector(post), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            uploadButton.widthAnchor.constraint(equalTo: imageLabel.widthAnchor),
            uploadButton.heightAnchor.constraint(equalTo: imageLabel.heightAnchor),
            uploadButton.bottomAnchor.constraint(equalTo: imageLabel.bottomAnchor),
            uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureSave() {
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerCurve = .circular
        saveButton.addTarget(self, action: #selector(saveClicked), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    @objc func post(){
        let alert = UIAlertController(title: "Upload Photos", message: "Upload photos from...", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (action: UIAlertAction!) in
            self.openPHPicker()
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction!) in
            let vc = CameraVC(user: self.user, loginEntry: self.loginEntry)
//            self.navigationController?.viewControllers = [vc]
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @objc func saveClicked() {
        print("save clicked")
        if nameField.text == "" {
            self.user.name = nameField.placeholder!
        }
        else {
            self.user.name = nameField.text ?? nameField.placeholder!
        }
        let compressedimg = imageLabel.image?.compress(to: 500)
        let def = UIImage(named: "pfp")?.PNGData
        self.user.img = compressedimg ?? def!
        
        if self.user._id == "" {
            // Save new user in server
            Task {
                let res = await postUser(u: self.user)
                switch res {
                case .success(let id):
                    let parsedID = String(Array(id)[1..<id.count-1])
                    self.user.setID(id: parsedID)
                    self.loginEntry.setInfoID(id: parsedID)
                    
                    // update loginentry info id in server
                    await updateLogin(l: self.loginEntry)
                    
                    let vc = TBController(user: self.user, loginEntry: self.loginEntry)
                    self.navigationController?.viewControllers = [vc]
                    
                case.failure(let error):
                    print(error)
                }
            }
        }
        else {
            // Update old user with new info
            print("starting put")
            let uservc = UserProfileVC(user: self.user, entry: self.loginEntry)
            self.navigationController?.viewControllers = [uservc, self]
            Task {
                let res = await putUser(u: self.user)
                switch res {
                case .success(_):
                    print("Update Success")
                case.failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func updateLogin(l: login) async {
        Task {
            let res = await loginPut(l: loginEntry)
            switch res {
            case .success(let id):
                print("Successfully updated login with id \(id)")
            case.failure(let error):
                print(error)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
}


extension EditProfileVC: UITextFieldDelegate, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    /// call this method for `PHPicker`
    func openPHPicker() {
        var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = PHPickerFilter.any(of: [.images, .livePhotos])
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        present(phPickerVC, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        if let itemprovider = results.first?.itemProvider{
          
            if itemprovider.canLoadObject(ofClass: UIImage.self){
                itemprovider.loadObject(ofClass: UIImage.self) { image , error  in
                    if let error{
                        print(error)
                    }
                    if let selectedImage = image as? UIImage{
                        DispatchQueue.main.async {
                            self.imageLabel.image = selectedImage
                        }
                    }
                }
            }
        }
//        results.forEach { result in
//            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
//                guard let image = reading as? UIImage, error == nil else { return }
//                DispatchQueue.main.async {
//                    
//                    if let data = image.compress(to: 500) {
//                        self.imageLabel.image = UIImage(data: data)
//                        self.user.img = data
//                        self.putUserImage(u:self.user)
//                    }
//                    
//                    // TODO: - Here you get UIImage
//                }
//                result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.image") { [weak self] url, _ in
//                    // TODO: - Here You Get The URL
//                }
//            }
//        }
    }
    
    
            
    func takePhotoFromGallery() {
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            if let data = pickedImage.compress(to: 500) {
                self.imageLabel.image = UIImage(data: data)
                self.user.img = data
                self.putUserImage(u:self.user)
            }
        }
        self.dismiss(animated: true)
    }
    
    
    func putUserImage(u:User){
        Task.init {
            let res = await putUser(u: self.user)
            switch res{
            case.success(let id):
                print("Update PFP success with id \(id)")
            case.failure(let error):
                print(error)
            }
        }
    }
}

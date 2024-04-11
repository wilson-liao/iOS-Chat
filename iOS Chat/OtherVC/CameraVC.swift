//
//  CameraVC.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/11.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController, AVCapturePhotoCaptureDelegate {

    var session: AVCaptureSession?
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    let shutterButton: UIButton = {
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        b.layer.cornerRadius = 50
        b.layer.borderWidth = 10
        b.layer.borderColor = UIColor.white.cgColor
        return b
    }()
    let retakeButton = UIButton()
    let useButton = UIButton()
    let cancelButton = UIButton()
    let flipButton = UIButton()
    
    var tempImage: UIImage?
    var cameraPos = CameraType.Back
    
    var user: User!
    var loginEntry: login!
    
    enum CameraType {
        case Front
        case Back
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        configCameraLayer()
        checkCameraPermissions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds

        shutterButton.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height - 100)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        
        
        flipButton.translatesAutoresizingMaskIntoConstraints = false
        flipButton.configuration = .plain()
        flipButton.configuration?.image = UIImage(systemName: "arrow.triangle.2.circlepath.camera")
        flipButton.configuration?.image?.withTintColor(.white)
        flipButton.addTarget(self, action: #selector(flipClicked), for: .touchUpInside)
        flipButton.configuration?.baseForegroundColor = .white
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            cancelButton.widthAnchor.constraint(equalToConstant: 70),
            cancelButton.heightAnchor.constraint(equalToConstant: 70),
            
            flipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            flipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            flipButton.widthAnchor.constraint(equalToConstant: 70),
            flipButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    
    init(user: User, loginEntry: login){
        super.init(nibName: nil, bundle: nil)
        
        self.user = user
        self.loginEntry = loginEntry
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCameraLayer() {
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        view.addSubview(cancelButton)
        view.addSubview(flipButton)
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
    }
    
    @objc func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(),
                            delegate: self)
    }
    
    @objc func cancelClicked() {
        print("cancel clicked")
        self.navigationController?.isNavigationBarHidden = false
        let uservc = UserProfileVC(user: self.user, entry: self.loginEntry)
        let editvc = EditProfileVC(user: self.user, loginEntry: self.loginEntry)
        var stack = self.navigationController?.viewControllers
        stack! = [uservc, editvc]
        self.navigationController?.viewControllers = stack!
    }
    
    @objc func flipClicked() {
        print("flip clicked")
        let device: AVCaptureDevice?
        if cameraPos == .Back {
            device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
            cameraPos = .Front
        }
        else {
            device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
            cameraPos = .Back
        }
        do {
            for i in self.session!.inputs {
                self.session!.removeInput(i);
            }
            let input = try AVCaptureDeviceInput(device: device!)
            if session!.canAddInput(input){
                session?.addInput(input)
            }
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.session = session
            DispatchQueue.global(qos: .background).async {
                self.session?.startRunning()
            }
        }
        catch {
            print(error)
        }
        
        
    }
    
    func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .notDetermined:
            //Request
            print("requested")
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .restricted:
            print("restricted")
            break
        case .denied:
            print("denied")
            break
        case .authorized:
            print("permitted")
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input){
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                DispatchQueue.global(qos: .background).async {
                    session.startRunning()
                }
                self.session = session
            }
            catch {
                print(error)
            }
        }
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        guard let data = photo.fileDataRepresentation() else { return }
        session?.stopRunning()
        self.tempImage = UIImage(data: data)
        
        configRetakeUse()
    }
    
    func configRetakeUse() {
        flipButton.isEnabled = false
        view.addSubview(retakeButton)
        retakeButton.translatesAutoresizingMaskIntoConstraints = false
        
        retakeButton.setTitle("Retake Photo", for: .normal)
        retakeButton.titleLabel?.font = UIFont(name: "systemFont", size: 20)
        retakeButton.addTarget(self, action: #selector(retakeClicked), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            retakeButton.centerYAnchor.constraint(equalTo: shutterButton.centerYAnchor),
            retakeButton.trailingAnchor.constraint(equalTo: shutterButton.leadingAnchor, constant: -30)
        ])
        
        view.addSubview(useButton)
        useButton.translatesAutoresizingMaskIntoConstraints = false
        
        useButton.setTitle("Use Photo", for: .normal)
        useButton.titleLabel?.font = UIFont(name: "systemFont", size: 20)
        useButton.addTarget(self, action: #selector(useClicked), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            useButton.centerYAnchor.constraint(equalTo: shutterButton.centerYAnchor),
            useButton.leadingAnchor.constraint(equalTo: shutterButton.trailingAnchor, constant: 30)
        ])
    }
    
    func removeRetakeUse() {
        retakeButton.removeFromSuperview()
        useButton.removeFromSuperview()
    }
    
    @objc func retakeClicked() {
        flipButton.isEnabled = true
        removeRetakeUse()
        DispatchQueue.global(qos: .background).async {
            self.session?.startRunning()
        }
    }
    
    @objc func useClicked() {
        self.user.img = (tempImage?.PNGData!)!
        self.navigationController?.isNavigationBarHidden = false
//        let uservc = UserProfileVC(user: self.user, entry: self.loginEntry)
//        let editvc = EditProfileVC(user: self.user, loginEntry: self.loginEntry)
        let cropvc = CropImageVC(user: self.user, loginEntry: self.loginEntry)
//        var stack = [uservc, editvc, cropvc]
//        self.navigationController?.viewControllers = stack
        self.navigationController?.pushViewController(cropvc, animated: true)
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

//
//  CropImageVC.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/4/11.
//

import UIKit
import CropViewController

class CropImageVC: UIViewController, CropViewControllerDelegate {

    var user: User?
    var loginEntry: login?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let img = UIImage(data: self.user!.img)
        showCrop(image: img!)
    }
    
    init(user: User, loginEntry: login){
        super.init(nibName: nil, bundle: nil)
        
        self.user = user
        self.loginEntry = loginEntry
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showCrop(image: UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.view.backgroundColor = .red
        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = false
        vc.toolbarPosition = .bottom
        vc.doneButtonColor = .red
        vc.cancelButtonColor = .red
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
        var stack = self.navigationController?.viewControllers
        let len = stack!.count
        stack?.remove(at: len-1)
        self.navigationController?.viewControllers = stack!
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        let data = image.PNGData
        self.user?.img = data!
        
        let uservc = UserProfileVC(user: self.user!, entry: self.loginEntry!)
        let editvc = EditProfileVC(user: self.user!, loginEntry: self.loginEntry!)
        let stack = [uservc, editvc]
        self.navigationController?.viewControllers = stack
        
        cropViewController.dismiss(animated: true)
    }
}

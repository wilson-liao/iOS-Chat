//
//  MainVC.swift
//  iOS Chat
//
//  Created by Wilson Liao on 2024/3/27.
//

import UIKit

class TBController: UITabBarController {
    
    var user: User!
    var loginEntry: login!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    init(user: User, loginEntry: login) {
        super.init(nibName: nil, bundle: nil)
        
        self.user = user
        self.loginEntry = loginEntry
        setTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTabBar() {
//        let upVC = UserProfileVC()
//        let nVC = newVC()
        
//        upVC.title = "User Profile"
//        nVC.title = "New"
//        
//        self.setViewControllers([nVC,upVC], animated: false)
//        let imageList = ["folder","person.fill"]
//        let count = imageList.count - 1
//        guard let items = self.tabBar.items else { return }
//        
//        for x in 0...count {
//            items[x].image = UIImage(systemName: imageList[x])
//        }
//        
        self.tabBar.tintColor = .black
        self.tabBar.backgroundColor = .white
        viewControllers = [
                    createTabBarItem(tabBarTitle: "Contacts",
                                     tabBarImage: "book.pages",
                                     viewController: ContactsVC(user: self.user)),
                    createTabBarItem(tabBarTitle: "Chats",
                                     tabBarImage: "message",
                                     viewController: ChatVC(u: self.user)),
                    createTabBarItem(tabBarTitle: "Profile",
                                     tabBarImage: "person",
                                     viewController: UserProfileVC(user: self.user, entry: self.loginEntry))
                ]
    }
    
    func createTabBarItem(tabBarTitle: String, tabBarImage: String, viewController: UIViewController) -> UINavigationController{
        let navCont = UINavigationController(rootViewController: viewController)
        
        navCont.tabBarItem.title = tabBarTitle
        navCont.tabBarItem.image = UIImage(systemName: tabBarImage)
        
        // Nav Bar Customisation
        navCont.navigationBar.barTintColor = .green
        navCont.navigationBar.tintColor = .black
        navCont.navigationBar.isTranslucent = true

        return navCont
    }
}

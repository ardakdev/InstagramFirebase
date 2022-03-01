//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Ardak on 17.02.2022.
//

import Firebase
import UIKit


final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController()
                navController.modalPresentationStyle = .fullScreen
                navController.pushViewController(LoginController(), animated: true  )
                self.present(navController, animated: true)
            }
            return
        }
        setupViewControllers()
    }

    func setupViewControllers() {
        let redVC = UIViewController()
        redVC.title = "RedVC"
        redVC.tabBarItem.image = UIImage(systemName: "plus.app")
        redVC.tabBarItem.selectedImage = UIImage(systemName: "plus.app.fill")
        redVC.view.backgroundColor = .red

        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: userProfileController)
        navController.tabBarItem.image = UIImage(systemName: "person")
        navController.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        tabBar.backgroundColor = .gray
        tabBar.tintColor = .red
        tabBar.unselectedItemTintColor = .blue
        viewControllers = [navController, redVC]
    }
}

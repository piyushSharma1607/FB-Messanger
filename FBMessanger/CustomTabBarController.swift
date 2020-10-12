//
//  CustomTabBarController.swift
//  FBMessanger
//
//  Created by Piyush Sharma on 11/10/20.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Custom View Controllers
        let layout = UICollectionViewFlowLayout()
        let friendsController = FriendsController(collectionViewLayout: layout)
        let recentMessagesNavController = UINavigationController(rootViewController: friendsController)
        recentMessagesNavController.tabBarItem.title = "Recent"
        recentMessagesNavController.tabBarItem.image = UIImage(named: "recent")

        
        viewControllers = [recentMessagesNavController, createDummyNavControllerWithTitle(title: "Calls", imageName: "call"), createDummyNavControllerWithTitle(title: "Group", imageName: "group"), createDummyNavControllerWithTitle(title: "People", imageName: "people"), createDummyNavControllerWithTitle(title: "Settings", imageName: "settings")]
        
    }
    
    private func createDummyNavControllerWithTitle(title: String, imageName: String) -> UINavigationController {
        
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
    }
    
}

//
//  MainTabBarController.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-01.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        styleTabBar()
        setupViewControllers()
    }

    private func styleTabBar() {
        tabBar.backgroundColor = .tertiarySystemGroupedBackground
    }
    
    private func setupViewControllers() {
        let tasksNC = setTasksNavigationController()
        let userNC = setUserNavigationController()
        setViewControllers([tasksNC, userNC], animated: true)
    }
    
    private func setTasksNavigationController() -> UINavigationController {
        let tasksVC = TasksViewController()
        let tasksNC = UINavigationController(rootViewController: tasksVC)
        
        hideNavigationBarLine(tasksNC.navigationBar)
        
        tasksNC.tabBarItem.image = UIImage(systemName: "newspaper")
        tasksNC.tabBarItem.title = "Tasks"
        tasksNC.tabBarItem.selectedImage = UIImage(systemName: "newspaper.fill")
        return tasksNC
    }
    
    private func setUserNavigationController() -> UINavigationController {
        let userVC = UserViewController()
        let userNC = UINavigationController(rootViewController: userVC)
        
        userNC.tabBarItem.image = UIImage(systemName: "person")
        userNC.tabBarItem.title = "User"
        userNC.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        return userNC
    }
    
    private func hideNavigationBarLine(_ navigationBar: UINavigationBar) {
        let img = UIImage()
        navigationBar.shadowImage = img
        navigationBar.setBackgroundImage(img, for: .default)
        navigationBar.isTranslucent = true
    }
}


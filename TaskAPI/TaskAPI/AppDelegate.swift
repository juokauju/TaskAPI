//
//  AppDelegate.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-01.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
//        let vc = DetailViewController(task: task)
//
//        let nc = UINavigationController(rootViewController: vc)
        window?.rootViewController = LoginViewController()

        registerForNotifications()
        
        return true
    }
}

extension AppDelegate {
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout), name: .logout, object: nil)
    }
    
    @objc func didLogout() {
        pushRootViewController(LoginViewController())
     }
    
    private func pushRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
                return
            }
            
            let transition = CATransition()
            transition.type = .push
            transition.subtype = .fromLeft
            transition.duration = 0.3
            window.layer.add(transition, forKey: kCATransition)
            
            window.rootViewController = vc
            window.makeKeyAndVisible()
        }
}

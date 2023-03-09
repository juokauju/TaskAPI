//
//  UserViewController.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-06.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User"

        setUsername()
        styleUserImageView()
        setupNavigationBar()
    }
    
    private func setUsername() {
        guard let username = UserManager.username else { return }
        usernameLabel.text = username
    }
    
    private func styleUserImageView() {
        userImageView.layer.shadowColor = UIColor.black.cgColor
        userImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        userImageView.layer.shadowOpacity = 0.7
        userImageView.layer.shadowRadius = 2
    }
    
    private func setupNavigationBar() {
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.backgroundColor = .tertiarySystemGroupedBackground
        
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        setupDeleteNavigationBarItem()
    }
    
    private func setupDeleteNavigationBarItem() {
        let iconImage = UIImage(systemName: "trash.fill")
        let addBarItem = UIBarButtonItem(image: iconImage, style: .plain, target: self, action: #selector(addBarButtonTapped))
        navigationItem.rightBarButtonItem = addBarItem
        addBarItem.tintColor = .systemRed
    }
    
    @objc private func addBarButtonTapped(_ sender: UIBarButtonItem) {
        print("op")
        // alert action sheet y/n
        // delete user
        // if error, show error alert
        // pop to loginscreen
    }
}

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
        scrollEdgeAppearance.shadowColor = .clear
        
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        setupDeleteNavigationBarItem()
    }
    
    private func setupDeleteNavigationBarItem() {
        let iconImage = UIImage(systemName: "trash.fill")
        let addBarItem = UIBarButtonItem(image: iconImage, style: .plain, target: self, action: #selector(deleteBarButtonTapped))
        navigationItem.rightBarButtonItem = addBarItem
        addBarItem.tintColor = .systemRed
    }
    
    private func logoutUser() {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
}

// MARK: - Action
extension UserViewController {
    @objc private func deleteBarButtonTapped(_ sender: UIBarButtonItem) {
        showDeletionActionSheet { [weak self] in
            self?.delete()
        }
    }
    
    private func delete() {
        deleteUser { [weak self] deleted, error in
            if deleted {
                self?.showDeletedAlert {
                    self?.logoutUser()
                }
            } else {
                self?.handle(error)
            }
        }
    }
}

// MARK: - Networking
extension UserViewController {
    private func deleteUser(completion: @escaping (Bool, NetworkError?) -> Void) {
        guard let id = UserManager.userId else {
            completion(false, NetworkError.wrongId)
            return
        }
        
        TaskAPIService.shared.deleteUser(id: id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    completion(true, nil)
                case .failure(let error):
                    completion(false, error)
                }
            }
        }
    }
    
    private func handle(_ error: NetworkError?) {
        switch error {
        case .badUrl:
            showErrorAlert(message: "There was an error executing the deletion. Please try again.")
        case .httpRequestError:
            showErrorAlert(message: "There was an error with the HTTP request. Please try again.")
        case .networkFailure:
            showErrorAlert(message: "There was a network error. Please check your connection.")
        case .wrongId:
            showErrorAlert(message: "There was an error with user ID. Please try again later. ")
        case .none:
            break
        }
    }
}

// MARK: - Alerts
extension UserViewController {
    private func showDeletionActionSheet(action: @escaping () -> Void) {
        let alert = AlertBuilder(viewController: self, title: "Do you want to delete user?", message: nil, messageTwo: nil, messageThree: nil)
        alert.showYesNoActionSheet(action: action)
    }
    
    private func showErrorAlert(message: String) {
        let alert = AlertBuilder(viewController: self, title: "Error!", message: message, messageTwo: nil, messageThree: nil)
        alert.showAlertWithOK()
    }
    
    private func showDeletedAlert(completion: @escaping () -> Void) {
        let alert = AlertBuilder(viewController: self, title: "Deleted!", message: "Please register again", messageTwo: nil, messageThree: nil)
        alert.showAlertWithOK(action: completion)
    }
}

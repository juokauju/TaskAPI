//
//  LoginViewController.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-01.
//

import UIKit

class LoginViewController: UIViewController {
    @UsesAutoLayout
    private var label = UILabel()
    
    @UsesAutoLayout
    private var textFieldStackView = UIStackView()
    
    private weak var usernameTextField: TextFieldView!
    private weak var passwordTextField: TextFieldView!
    
    @UsesAutoLayout
    private var logButton = UIButton()
    
    @UsesAutoLayout
    private var questionStackView = UIStackView()
    
    @UsesAutoLayout
    private var questionLabel = UILabel()
    
    @UsesAutoLayout
    private var changeViewButton = UIButton()
    
    private var isScreenLogin = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - View Setup
extension LoginViewController {
    private func setupView() {
        view.backgroundColor = .systemBlue
        
        label.text = "TaskAPI"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        
        setupTextFieldStackView()
        setupLogButton()
        setupQuestionStackView()
        setTitlesLoginOrRegister()
        setupDismissKeyboardGesture()
    }
    
    private func setupTextFieldStackView() {
        @UsesAutoLayout
        var usernameTextField = TextFieldView(title: "Username:", placeholder: "Enter username")
        @UsesAutoLayout
        var passwordTextField = TextFieldView(title: "Password:", placeholder: "Enter password")
        
        self.usernameTextField = usernameTextField
        self.passwordTextField = passwordTextField
        
        textFieldStackView.axis = .vertical
        textFieldStackView.spacing = 15
        
        textFieldStackView.addArrangedSubview(usernameTextField)
        textFieldStackView.addArrangedSubview(passwordTextField)
        
        view.addSubview(textFieldStackView)
        
        NSLayoutConstraint.activate([
            textFieldStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func setupLogButton() {
        var config = UIButton.Configuration.filled()
        config.titleAlignment = .center
        config.titlePadding = 20
        config.buttonSize = .large
        config.baseBackgroundColor = .black
        config.cornerStyle = .large
        
        logButton.configuration = config
        logButton.addTarget(self, action: #selector(logButtonTapped), for: .primaryActionTriggered)
        
        view.addSubview(logButton)
        
        NSLayoutConstraint.activate([
            logButton.topAnchor.constraint(equalToSystemSpacingBelow: textFieldStackView.bottomAnchor, multiplier: 5),
            logButton.leftAnchor.constraint(equalTo: textFieldStackView.leftAnchor, constant: 40),
            logButton.rightAnchor.constraint(equalTo: textFieldStackView.rightAnchor, constant: -40)
        ])
    }
    
    private func setupQuestionStackView() {
        questionLabel.textColor = .white
        questionLabel.font = UIFont.preferredFont(forTextStyle: .body)

        changeViewButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        changeViewButton.addTarget(self, action: #selector(changeButtonTapped), for: .primaryActionTriggered)
        
        questionStackView.axis = .horizontal
        questionStackView.spacing = 4
        
        questionStackView.addArrangedSubview(questionLabel)
        questionStackView.addArrangedSubview(changeViewButton)
        
        view.addSubview(questionStackView)
        
        NSLayoutConstraint.activate([
            questionStackView.topAnchor.constraint(equalToSystemSpacingBelow: logButton.bottomAnchor, multiplier: 6),
            questionStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setTitlesLoginOrRegister() {
        if isScreenLogin {
            logButton.setTitle("Login", for: .normal)
            questionLabel.text = "Have no username?"
            changeViewButton.setTitle("Register!", for: .normal)
        } else {
            logButton.setTitle("Register", for: .normal)
            questionLabel.text = "Already registered?"
            changeViewButton.setTitle("Login!", for: .normal)
        }
    }
    
    private func setupDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_: )))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
}

// MARK: - Actions
extension LoginViewController {
    @objc func viewTapped(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == UIGestureRecognizer.State.ended {
            view.endEditing(true) // resign first responder
        }
    }
    
    @objc private func changeButtonTapped(_ sender: UIButton){
        isScreenLogin.toggle()
        setTitlesLoginOrRegister()
    }
    
    @objc private func logButtonTapped(_ sender: UIButton) {
        loginOrRegister()
    }
}

extension LoginViewController {
    private func loginOrRegister() {
        guard let user = createUserAuthenticationRequest() else { return }
        UserManager.username = user.username
        loginOrRegister(for: user)
    }
    
    private func createUserAuthenticationRequest() -> UserAuthenticationRequest? {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text
        else { return nil }
        let user = UserAuthenticationRequest(username: username,
                                             password: password)
        return user
    }
}


// MARK: - Networking
extension LoginViewController {
    private func loginOrRegister(for user: UserAuthenticationRequest) {
        if isScreenLogin {
            login(user)
        } else {
            register(user)
        }
    }
    
    private func login(_ user: UserAuthenticationRequest) {
        TaskAPIService().login(user: user) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userResponse):
                    self?.saveUserInfoInUserDefaults(userId: userResponse.userId,
                                                     username: user.username)
                    UserManager.userId = userResponse.userId
                    self?.moveToMainViewController()
                case .failure(let error):
                    print("Error fetching from login: \(error)")
                    self?.showLoginErrorAlert()
                }
            }
        }
    }
    
    private func register(_ user: UserAuthenticationRequest) {
        TaskAPIService().register(user: user) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userResponse):
                    self?.saveUserInfoInUserDefaults(userId: userResponse.userId,
                                                     username: user.username)
                    UserManager.userId = userResponse.userId
                    self?.moveToMainViewController()
                case .failure(let error):
                    print("Error fetching from register: \(error)")
                    self?.showErrorAlert()
                }
            }
        }
    }


    private func moveToMainViewController() {
        let tabVC = MainTabBarController()
        tabVC.modalPresentationStyle = .fullScreen
        tabVC.modalTransitionStyle = .crossDissolve
            self.present(tabVC, animated: true)
    }
    
    private func saveUserInfoInUserDefaults(userId: Int?, username: String) {
        guard let userId = userId else { return }
        let userInfo = UserInfo(id: userId, username: username)
        if let encode = try? JSONEncoder().encode(userInfo) {
            UserDefaults.standard.set(encode, forKey: "userInfo")
        }
    }
    
    private func showLoginErrorAlert() {
        let alert = AlertBuilder(viewController: self, title: "Invalid login!", message: "User credentials are incorrect. Please try again or register", messageTwo: nil, messageThree: nil)
        alert.showAlertWithOK(action: nil)
    }
    
    private func showErrorAlert() {
        let alert = AlertBuilder(viewController: self, title: "Error!", message: "Backend error presented", messageTwo: nil, messageThree: nil)
        alert.showAlertWithOK(action: nil)
    }
}


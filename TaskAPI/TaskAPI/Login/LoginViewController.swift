//
//  LoginViewController.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-01.
//

import UIKit

protocol LoginViewControllerDelegate: NSObject {
    func didLogin()
}

class LoginViewController: UIViewController {
    
    weak var delegate: LoginViewControllerDelegate?
    
    @UsesAutoLayout private var label = UILabel()
    @UsesAutoLayout private var textFieldStackView = UIStackView()
    
    private weak var usernameTextField: TextFieldView!
    private weak var passwordTextField: TextFieldView!
    @UsesAutoLayout private var logButton = UIButton()
    @UsesAutoLayout private var questionStackView = UIStackView()
    @UsesAutoLayout private var questionLabel = UILabel()
    @UsesAutoLayout private var changeViewButton = UIButton()
    
    private var isScreenLogin = true
    
    private let service = TaskAPIService()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - View Setup
extension LoginViewController {
    private func setup() {
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
        @UsesAutoLayout var usernameTextField = TextFieldView(title: "Username", placeholder: "Enter username")
        @UsesAutoLayout var passwordTextField = TextFieldView(title: "Password", placeholder: "Enter password")
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
    
    @objc private func logButtonTapped(_ sender: UIButton){
        guard let username = usernameTextField.text, let password = passwordTextField.text else { return }
        let user = UserAuthenticationRequest(username: username, password: password)
        loginOrRegister(for: user)
        delegate?.didLogin()
    }
    
    @objc private func changeButtonTapped(_ sender: UIButton){
        isScreenLogin.toggle()
        setTitlesLoginOrRegister()
    }
    
}

// MARK: - Networking
extension LoginViewController {
    private func loginOrRegister(for user: UserAuthenticationRequest) {
        if isScreenLogin {
            service.login(user: user) { [weak self] userResponse in
                guard let self = self else { return }
                self.save(userId: userResponse?.userId, for: user.username)
            }
        } else {
            service.register(user: user) { [weak self] userResponse in
                guard let self = self else { return }
                self.save(userId: userResponse?.userId, for: user.username)
            }
        }
    }
    
    private func save(userId: Int?, for username: String) {
        guard let userId = userId else { return }
        let userInfo = UserInfo(id: userId, username: username)
        if let encode = try? JSONEncoder().encode(userInfo) {
            UserDefaults.standard.set(encode, forKey: "userInfo")
        }
    }
}

//
//  DetailViewController.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-12.
//

import UIKit

class DetailViewController: UIViewController {
    
    @UsesAutoLayout var stackView = UIStackView()
    @UsesAutoLayout var updateButton = UIButton()
    
    private var task: TaskResponse

    init(task: TaskResponse) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layout()
    }
}

extension DetailViewController {
    private func setupView() {
        title = "Task"
        view.backgroundColor = .secondarySystemBackground
        setupStackView()
        setupUpdateButton()
        setupNavigationBar()
    }
    
    private func layout() {
        view.addSubview(stackView)
        view.addSubview(updateButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            updateButton.topAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 5),
            updateButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            updateButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
    }
    
    private func setupStackView() {
        stackView.spacing = 2
        stackView.axis = .vertical
        addTitleField()
        addDescriptionField()
        addEstimatedMinutesField()
        addStepperView()
        addAssigneeField()
    }
    
    private func addTitleField() {
        @UsesAutoLayout var titleField = TextFieldView(
            title: "Title",
            placeholder: "Enter title"
        )
        titleField.spaceBetweenLabelAndTextField = 117
        stackView.addArrangedSubview(titleField)
    }
    
    private func addDescriptionField() {
        @UsesAutoLayout var descriptionField = TextFieldView(
            title: "Description",
            placeholder: "Enter description"
        )
        descriptionField.spaceBetweenLabelAndTextField = 63
        stackView.addArrangedSubview(descriptionField)

    }

    private func addEstimatedMinutesField() {
        @UsesAutoLayout var estimatedMinutesField = TextFieldView(
            title: "Estimated minutes",
            placeholder: "Enter minutes"
        )
        estimatedMinutesField.textField.keyboardType = .asciiCapableNumberPad
        estimatedMinutesField.spaceBetweenLabelAndTextField = 10
        stackView.addArrangedSubview(estimatedMinutesField)
    }
    
    private func addStepperView() {
        @UsesAutoLayout var stepperView = StepperView()
        stepperView.configure(with: "Logged time", value: task.loggedTime, valueChangedHandler: { [weak self] newValue in
            stepperView.valueLabel.text = String(newValue)
            self?.task.loggedTime = newValue
        })
        stackView.addArrangedSubview(stepperView)
    }
    
    private func addAssigneeField() {
        @UsesAutoLayout var assigneeField = TextFieldView(title: task.assigneeInfo.username, placeholder: "")
        assigneeField.textField.isHidden = true
        stackView.addArrangedSubview(assigneeField)
    }
    
    private func setupUpdateButton() {
        var config = UIButton.Configuration.filled()
        config.title = "Update"
        config.titleAlignment = .center
        config.buttonSize = .large
        config.baseBackgroundColor = .black
        config.cornerStyle = .large
        updateButton.configuration = config
        addShadowUpdateButton()
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .primaryActionTriggered)
    }
    
    private func addShadowUpdateButton() {
        updateButton.layer.shadowColor = UIColor.gray.cgColor
        updateButton.layer.shadowOpacity = 1
        updateButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.0)
        updateButton.layer.shadowRadius = 3.0
    }
    
    private func setupNavigationBar() {
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.backgroundColor = .lightText
        
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        setupAddNavigationBarItem()
    }
    
    private func setupAddNavigationBarItem() {
        let iconImage = UIImage(systemName: "plus.square")
        let addBarItem = UIBarButtonItem(image: iconImage, style: .plain, target: self, action: #selector(addBarButtonTapped))
        navigationItem.rightBarButtonItem = addBarItem
    }
    
   
}

extension DetailViewController {
    @objc private func addBarButtonTapped(_ sender: UIBarButtonItem) {

    }
    
    @objc private func updateButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

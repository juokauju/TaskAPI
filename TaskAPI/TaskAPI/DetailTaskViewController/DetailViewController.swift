//
//  DetailViewController.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-12.
//

import UIKit

class DetailViewController: UIViewController {
    
    @UsesAutoLayout var stackView = UIStackView()

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
        setupNavigationBar()
    }
    
    private func layout() {
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setupStackView() {
        stackView.spacing = 2
        stackView.axis = .vertical
        addTitleField()
        addDescriptionField()
        addEstimatedMinutesField()
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
}

//
//  TextFieldView.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-01.
//

import UIKit

class TextFieldView: UIView {
    @UsesAutoLayout var label = UILabel()
    @UsesAutoLayout var textField = UITextField()
    
    var text: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    var spaceBetweenLabelAndTextField: CGFloat? {
        didSet {
            NSLayoutConstraint.deactivate(textFieldConstraints)
            setupTextField()
        }
    }
    
    let title: String
    let placeholder: String
    
    private var textFieldConstraints = [NSLayoutConstraint]()

    init(title: String, placeholder: String) {
        self.title = title
        self.placeholder = placeholder
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 350, height: 45)
    }
}

extension TextFieldView {
    private func setupView() {
        backgroundColor = .systemBackground
        setupLabel()
        setupTextField()
    }
    
    private func setupLabel() {
        label.text = title
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 0.5),
            label.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2)
        ])
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupTextField() {
        textField.placeholder = placeholder
        textField.textAlignment = .left
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .none
        textField.delegate = self
        
        addSubview(textField)
        textFieldConstraints = [
            textField.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            textField.leftAnchor.constraint(equalTo: label.rightAnchor, constant: spaceBetweenLabelAndTextField ?? 8),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(textFieldConstraints)
    }
}

extension TextFieldView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.endEditing(true) // resign first responder
            return true
        }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
           return true
        }
}

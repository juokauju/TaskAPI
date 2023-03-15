//
//  StepperView.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-12.
//

import UIKit

class StepperView: UIView {
    
    @UsesAutoLayout var titleLabel = UILabel()
    @UsesAutoLayout var valueLabel = UILabel()
    @UsesAutoLayout var stepper = UIStepper()
    
    var valueChangedHandler: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 350, height: 45)
    }
}

extension StepperView {
    private func setupView() {
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(stepper)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.rightAnchor.constraint(equalTo: stepper.leftAnchor, constant: -16),
            
            stepper.centerYAnchor.constraint(equalTo: centerYAnchor),
            stepper.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        valueChangedHandler?(Int(sender.value))
    }
}

extension StepperView {
    func configure(with title: String, value: Int, valueChangedHandler: ((Int) -> Void)?) {
        titleLabel.text = title
        valueLabel.text = "\(value)"
        stepper.value = Double(value)
        self.valueChangedHandler = valueChangedHandler
    }
}


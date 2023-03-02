//
//  StepperTableViewCell.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-02.
//

import UIKit

class StepperTableViewCell: UITableViewCell {

    static let reuseId = "StepperTableViewCell"
    
    @UsesAutoLayout var titleLabel = UILabel()
    @UsesAutoLayout var valueLabel = UILabel()
    @UsesAutoLayout var stepper = UIStepper()
    
    var valueChangedHandler: ((Int) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseId)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension StepperTableViewCell {
    private func setupView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(stepper)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.rightAnchor.constraint(equalTo: stepper.leftAnchor, constant: -8),
            
            stepper.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stepper.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8)
        ])
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        valueChangedHandler?(Int(sender.value))
    }
}

extension StepperTableViewCell {
    func configure(with title: String, value: Int, valueChangedHandler: ((Int) -> Void)?) {
        titleLabel.text = title
        valueLabel.text = "\(value)"
        stepper.value = Double(value)
        self.valueChangedHandler = valueChangedHandler
    }
}

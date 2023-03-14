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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
}

extension StepperView {
    
    private func style() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        
    }
}


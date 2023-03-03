//
//  TextFieldTableViewCell.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-02.
//

import UIKit

class ValueTableViewCell: UITableViewCell {
    
    static let reuseId = "TextFieldTableViewCell"
    
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: ValueTableViewCell.reuseId)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ValueTableViewCell {
    private func setupView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8)
        ])
        valueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

extension ValueTableViewCell {
    func configure(with title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}

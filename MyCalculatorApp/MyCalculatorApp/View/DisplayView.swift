//
//  DisplayView.swift
//  CalculatorApp
//
//  Created by Yuliya Martsenko on 15.01.2022.
//

import UIKit

class DisplayView: UIView {

    var label: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .right
        label.textColor = UIColor.white
        label.font = label.font.withSize(30)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.insetsLayoutMarginsFromSafeArea = true
        return label
    }()
    
    private func initSubviews() {
        addSubview(label)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
        setupConstraints()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        setupConstraints()
    }

}

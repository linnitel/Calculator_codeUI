//
//  CalculatorView.swift
//  CalculatorApp
//
//  Created by Yuliya Martsenko on 15.01.2022.
//

import UIKit

class CalculatorView: UIView {
    
    weak var output: CalculatorViewOutput?
    
    var buttonTitles: [[String]] = [["ac", "neg", "/"], ["1", "2", "3", "x"], ["4", "5", "6", "+"], ["7", "8", "9", "-"], ["0", "="]] {
        didSet {
            resetButtonsStack()
            setNeedsDisplay()
        }
    }

    // Display, where result of the calculation and inserted numbers are shown
    var display: DisplayView = {
        let view = DisplayView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var buttons = [[UIButton]]()
    
    var buttonStackArray = [UIStackView]()
    
    var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func setupOutput(output: CalculatorViewOutput) {
        self.output = output
    }
    
    @objc
    func performOperation(_ sender: UIButton?) {
        guard let button = sender else {
            return
        }
        output?.buttonDidTap(sender)
        guard let label = button.titleLabel?.text else {
            print("Unknown button was tapped")
            return
        }
        print("Button \(label) was tapped")
      }
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: UIControl.State.normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.font = button.titleLabel?.font.withSize(30)
        button.backgroundColor = UIColor.orange
        button.addTarget(self, action: #selector(performOperation), for: .touchUpInside)
        return button
    }
    
    private func createButtonRow(from titleRow: [String]) -> [UIButton] {
        var buttonRow = [UIButton]()
        for title in titleRow {
            let button = createButton(title: title)
            buttonRow.append(button)
        }
        return buttonRow
    }
    
    private func createButtonsRowStack(from buttons: [UIButton]) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 10
        buttons.forEach { button in
            stack.addArrangedSubview(button)
        }
        return stack
    }
    
    private func createButtonsStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    private func resetButtonsStack() {
        buttonsStack.arrangedSubviews.forEach { stack in
            buttonsStack.removeArrangedSubview(stack)
            stack.removeFromSuperview()
        }
        buttons.removeAll()
        buttonStackArray.removeAll()
        for titleRow in buttonTitles {
            let buttonsRow = createButtonRow(from: titleRow)
            buttons.append(buttonsRow)
            let stack = createButtonsRowStack(from: buttonsRow)
            buttonStackArray.append(stack)
        }
        buttonStackArray.forEach { stack in
            buttonsStack.addArrangedSubview(stack)
        }

    }
    
    private func initSubviews() {
        resetButtonsStack()
        addSubview(display)
        addSubview(buttonsStack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            display.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            display.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            display.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            display.heightAnchor.constraint(equalToConstant: 50),
            
            buttonsStack.topAnchor.constraint(equalTo: display.bottomAnchor, constant: 16),
            buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
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

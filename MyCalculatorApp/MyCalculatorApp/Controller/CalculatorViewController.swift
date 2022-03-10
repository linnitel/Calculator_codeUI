//
//  CalculatorViewController.swift
//  CalculatorApp
//
//  Created by Yuliya Martsenko on 15.01.2022.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    private var calculatorModel = CalculatorModel()
    private var calculatorView: CalculatorView = {
        let view = CalculatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var inTheMiddleOfTyping = false
    
    var titles: [[String]]?
    
    var displayValue: Double {
        get {
            guard let text = calculatorView.display.label.text,
                  let double = Double(text) else {
                      return 0
                  }
            return double
        }

        set {
            calculatorView.display.label.text = String(newValue)
        }
    }
    
    @objc
    func performOperation(_ sender: UIButton) {
        guard let symbol = sender.titleLabel?.text else {
            return
        }
        if inTheMiddleOfTyping {
            calculatorModel.setOperand(operand: displayValue)
            inTheMiddleOfTyping = false
        }
        calculatorModel.performOperation(symbol: symbol)
        displayValue = calculatorModel.result
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            calculatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calculatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calculatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calculatorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        calculatorView.setupOutput(output: self)
        view.addSubview(calculatorView)
        setupConstraints()
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            calculatorView.buttonTitles = [["ac", "neg", "/", "x"], ["1", "2", "3", "4", "+"], ["5", "6", "7", "8", "-"], ["9", "0", "="]]
        } else {
            calculatorView.buttonTitles = [["ac", "neg", "/"], ["1", "2", "3", "x"], ["4", "5", "6", "+"], ["7", "8", "9", "-"], ["0", "="]]
        }
    }

}

extension CalculatorViewController: CalculatorViewOutput {
    
    private func touchedDigit(with digit: String) {
        guard let currentDisplayText = calculatorView.display.label.text else {
            calculatorView.display.label.text = digit
            return
        }
        if inTheMiddleOfTyping {
            calculatorView.display.label.text = currentDisplayText + digit
        } else {
            calculatorView.display.label.text = digit
            inTheMiddleOfTyping = true
        }
    }
    
    private func touchedOperation(with operand: String) {
        if inTheMiddleOfTyping {
            calculatorModel.setOperand(operand: displayValue)
            inTheMiddleOfTyping = false
        }
        calculatorModel.performOperation(symbol: operand)
        displayValue = calculatorModel.result
    }
    
    
    func buttonDidTap(_ sender: UIButton?) {
        guard let symbol = sender?.titleLabel?.text else {
            return
        }
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = symbol.rangeOfCharacter(from: decimalCharacters)
        if decimalRange != nil {
            touchedDigit(with: symbol)
            print("Number button was tapped")
        } else {
            touchedOperation(with: symbol)
            print("Operation button was tapped")
        }
    }
}

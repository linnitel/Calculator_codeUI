//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Julia Martsenko on 14.10.2021.
//

import Foundation

class CalculatorModel {
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double)->Double)
        case BinaryOperation((Double, Double)->Double)
        case Equals
    }
    
    private struct binaryOperationData {
        var binaryOperation: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    private var accumulator = 0.0
    
    private var operations: [String: Operation] = [
        "+": Operation.BinaryOperation(+),
        "-": Operation.BinaryOperation(-),
        "x": Operation.BinaryOperation(*),
        "/": Operation.BinaryOperation(/),
        "neg": Operation.UnaryOperation{ -$0 },
        "ac": Operation.UnaryOperation{ _ in 0.0 },
        "=": Operation.Equals
    ]
    
    private var pending: binaryOperationData?
    
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
   private func executePendingOperation() {
        if pending != nil,
           let function = pending?.binaryOperation,
           let firstOperand = pending?.firstOperand {
            accumulator = function(firstOperand, accumulator)
            pending = nil
        }
    }
    
    func performOperation(symbol: String) {
        if let operations = operations[symbol] {
            switch operations {
            case .Constant(let associatedConstantValue):
                accumulator = associatedConstantValue
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingOperation()
                pending = binaryOperationData(binaryOperation: function, firstOperand: accumulator)
            case .Equals:
                executePendingOperation()
            }
        }
    }
}

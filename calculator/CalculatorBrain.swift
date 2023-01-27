//
//  CalculatorBrain.swift
//  calculator
//
//  Created by cnu on 2023/01/27.
//

import Foundation

//func changeSign(operand: Double) -> Double {
//    return -operand
//}

//func multiply(op1: Double, op2: Double) -> Double {
//    return op1 * op2
//}

class CalculatorModel: ObservableObject {
    
    @Published var displayValue: String = "0"
    
    private let buttonCodeVertical: [[String]] = [
        ["C", "±", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="],
    ]
    private let buttonCodeHorizontal: [[String]] = [
        ["(",   ")",    "mc",   "m+",   "m-",   "mr",   "C",    "±",    "%",    "÷"],
        ["2nd", "x²",   "x³",   "xʸ",   "eˣ",   "10ˣ",  "7",    "8",    "9",    "×"],
        ["√x",  "2/x",  "3/x",  "y/x",  "ln",   "log10","4",    "5",    "6",    "−"],
        ["x!",  "sin",  "cos",  "tan",  "e",    "EE",   "1",    "2",    "3",    "+"],
        ["Rad", "sinh", "cosh", "tanh", "pi",   "Rand", "0",    "0",    ".",    "="]
    ]
    
    private enum Operation {
        case unaryOperation ( (Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "C" : Operation.unaryOperation({$0 * 0}),
        "±" : Operation.unaryOperation({-$0}),
        "%" : Operation.unaryOperation({$0 / 100.0}),
        "×" : Operation.binaryOperation({$0 * $1}),
        "-" : Operation.binaryOperation({$0 - $1}),
        "+" : Operation.binaryOperation({$0 + $1}),
        "÷" : Operation.binaryOperation({$0 / $1}),
        "=" : Operation.equals
    ]
    func getButtonCodeList() -> [[String]] {
        return buttonCodeVertical
    }
    
    func inputToken(input:String) {
        if let _ = Int(input) {
            inputDigit(input: input)
        }
        else {
            if userIsInTheMiddleOfTyping, let value =
                Double(displayValue) {
                setOperand(operand: value)
                userIsInTheMiddleOfTyping = false
            }
            performOperation(input)
            if let value = result {
                displayValue = String(value)
            }
           
        }
    }
    
    private var userIsInTheMiddleOfTyping = false
    
    private func inputDigit(input: String) {
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = displayValue
            displayValue = textCurrentlyInDisplay + input
        } else {
            displayValue = input
            userIsInTheMiddleOfTyping = true
        }
    }
    
    private var accumulator: Double?
    
    private func performOperation(_ symbol: String) {
        if let operation = operations[symbol] { // 문자를 받아서 operations 함수에 넣어줌
            switch operation {
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pbo = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingbinaryOperation()
            }
        }
    }
    
    private func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var result: Double? {
        get {
            return accumulator
        }
    }
    
    private var pbo: PendingBinaryOperation?
    
    private func performPendingbinaryOperation() {
        if let pend = pbo, let accum = accumulator {
            accumulator = pend.perform(with: accum)
            pbo = nil
        }
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand : Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
}

//nil 값 정리를 위해 C를 enum Operation을 하나더 만들고 nil 값 초기화 부분을 넣어주는게 좋다

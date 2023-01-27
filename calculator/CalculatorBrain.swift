//
//  CalculatorBrain.swift
//  calculator
//
//  Created by cnu on 2023/01/27.
//

import Foundation

class CalculatorModel: ObservableObject {
    
    @Published var displayValue: String = "0"
    
    private let buttonCodeVertical: [[String]] = [
        ["C", "±", "%", "÷"],
        ["7", "8", "9", "x"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ",", "="],
]
    private let buttonCodeHorizontal: [[String]] = [
        ["(",   ")",    "mc",   "m+",   "m-",   "mr",   "C",    "±",    "%",    "÷"],
        ["2nd", "x²",   "x³",   "xʸ",   "eˣ",   "10ˣ",  "7",    "8",    "9",    "×"],
        ["√x",  "2/x",  "3/x",  "y/x",  "ln",   "log10","4",    "5",    "6",    "−"],
        ["x!",  "sin",  "cos",  "tan",  "e",    "EE",   "1",    "2",    "3",    "+"],
        ["Rad", "sinh", "cosh", "tanh", "pi",   "Rand", "0",    "0",    ".",    "="]
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
            displayValue = String(result)
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
    
    private func performOperation(_ symbol:String) {
        userIsInTheMiddleOfTyping = false
    }
    
    private func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var result: Double {
        get {
            return accumulator!
        }
    }
    
    
    
}

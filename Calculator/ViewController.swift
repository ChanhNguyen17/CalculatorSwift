//
//  ViewController.swift
//  Calculator
//
//  Created by Chanh Nguyen on 1/18/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

var calculatorCount = 0

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    private var userIsTypingDecimal = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorCount += 1
        print("Loaded up a new Calculator: count = \(calculatorCount)")
        brain.addunaryOperation(symbol: "Z", operation: { [weak weakSelf = self] in
            weakSelf?.display.textColor = UIColor.red
            return sqrt($0)
        })
    }
    
    deinit {
        calculatorCount -= 1
        print("Calculator left the heap: count = \(calculatorCount)")
    }

    @IBAction private func touchButton(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            
            if digit == "."{
                if userIsTypingDecimal {
                    return
                } else {
                    userIsTypingDecimal = true
                }
            }else{
                userIsTypingDecimal = false
            }
            
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            
        }
        userIsInTheMiddleOfTyping = true
        
        print("touched \(digit) digit")
    }
    
    private var displayValue: Double {
        get {
            if userIsTypingDecimal {
                userIsTypingDecimal = false
                var displayText = display.text!
                let index = displayText.index(before: displayText.endIndex)
                displayText = displayText.substring(to: index)
                
                return Double(displayText) ?? 0.0
            }
            return Double(display.text!)!
        }
        set{
            let oneBillion = pow(10.0, 12.0)
            let roundedValue = round(newValue * oneBillion)/oneBillion
            display.text = String(roundedValue)
        }
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
    }
    
    @IBAction func clearButton(_ sender: Any) {
        userIsInTheMiddleOfTyping = false
        userIsTypingDecimal = false
        brain.clear()
        display.text = "0"
    }
    
}










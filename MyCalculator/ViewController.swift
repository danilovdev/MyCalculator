//
//  ViewController.swift
//  MyCalculator
//
//  Created by Alexey Danilov on 24/09/2017.
//  Copyright © 2017 DanilovDev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum MathOperation: Int {
        case PLUS = 0
        case MINUS = 1
        case MULTIPLY = 2
        case DIVIDE = 3
        case EQUALS = 4
    }
    
    enum ModifyOperation: Int {
        case PLUS_MINUS = 0
        case PERCENTAGE = 1
        case COMMA = 2
        case CLEAR = 3
    }
    
    var currentNumber: Double = 0
    
    var previousNumber: Double = 0
    
    var currentCommandButton: UIButton!
    
    var performingMath = false
    
    var currentOperation: MathOperation!
    
    var numberFormatter: NumberFormatter!
    
    @IBOutlet var valueLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = " "
        
        // https://stackoverflow.com/questions/9006208/swipe-gesture-added-to-uilabel-but-its-not-working
        self.valueLabel.isUserInteractionEnabled = true
        
        // https://stackoverflow.com/questions/17540481/add-uigesturerecognizer-to-swipe-left-to-right-right-to-left-my-views
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.removeLastSymbol))
        swipeRightGestureRecognizer.direction = .right
        self.valueLabel.addGestureRecognizer(swipeRightGestureRecognizer)
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.removeLastSymbol))
        swipeLeftGestureRecognizer.direction = .left
        self.valueLabel.addGestureRecognizer(swipeLeftGestureRecognizer)
    }
    
    @IBAction func commandTapped(sender: UIButton) {
        
        
        
        if sender.tag == 11 {
            self.previousNumber = 0.0
            self.currentNumber = 0.0
            self.valueLabel.text = "0"
            clearCommandButton()
            return
        }
        
        if sender.tag == 18 {
            
            if self.currentOperation == MathOperation.PLUS {
                let valueText = self.numberFormatter.string(for: (self.previousNumber + self.currentNumber))
                self.valueLabel.text = valueText
                self.currentNumber = self.previousNumber + self.currentNumber
                self.previousNumber = 0.0
            }
            
            clearCommandButton()
            return
        }
        
        self.previousNumber = self.currentNumber
        
        if sender.tag == 17 {
            self.currentOperation = MathOperation.PLUS
        }
        
        let updateCommandButton = {
            self.currentCommandButton = sender
            self.currentCommandButton.layer.borderColor = UIColor.black.cgColor
            self.currentCommandButton.layer.borderWidth = 2.0
        }
        
        if self.currentCommandButton != nil {
            if self.currentCommandButton.tag != sender.tag {
                self.currentCommandButton.layer.borderColor = UIColor.clear.cgColor
                self.currentCommandButton.layer.borderWidth = 0.0
                updateCommandButton()
            }
        } else {
            updateCommandButton()
        }
        
        self.performingMath = true
    
    }
    
    @IBAction func numberTapped(sender: UIButton) {
        self.clearCommandButton()
        var value = 0.0
        
        if self.valueLabel.text == "0" || self.performingMath {
            value = Double(sender.tag - 1)
        } else {
            let newStr = (self.valueLabel.text! + String(sender.tag - 1)).replacingOccurrences(of: " ", with: "")
            value = self.numberFormatter.number(from: newStr)!.doubleValue
            
        }
        self.currentNumber = value
        self.valueLabel.text = self.numberFormatter.string(for: value)
    }
    
    @objc func removeLastSymbol(sender: UISwipeGestureRecognizer) {
        print("will be removed")
    }
    
    func clearCommandButton() {
        if self.currentCommandButton != nil {
            self.currentCommandButton.layer.borderColor = UIColor.clear.cgColor
            self.currentCommandButton.layer.borderWidth = 0.0
            self.currentCommandButton = nil
        }
    }


}


//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Виктория Бадисова on 23.05.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet { updateCelsiusLabel() }
    }
    
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ConversionViewController loaded it's view.")
        updateCelsiusLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        switchDarkMode()
        changeBackgroundColor()
        super.viewWillAppear(animated)
    }
    
    func switchDarkMode() {
        let date = Date()
        let hour = Calendar.current.component(.hour, from: date)
        if hour > 17 || hour < 6 {
            self.view.backgroundColor = .darkGray
        } else {
            self.view.backgroundColor = UIColor(red: 245/250, green: 244/250, blue: 241/250, alpha: 1)
        }
    }
    
    func changeBackgroundColor() {
        var randomCGFloat: CGFloat {return CGFloat(arc4random_uniform(249) + 1) / 250}
        self.view.backgroundColor = UIColor(red: randomCGFloat, green: randomCGFloat, blue: randomCGFloat, alpha: 1)
    }
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789.")
        let replacementCharacterSet = CharacterSet(charactersIn: string)
        
        if !replacementCharacterSet.isSubset(of: allowedCharacterSet) {
            return false
        }
        
        if existingTextHasDecimalSeparator != nil,
            replacementTextHasDecimalSeparator != nil{
            return false
        } else {
            return true
        }
    }
}

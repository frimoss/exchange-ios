//
//  AmountTextField.swift
//  exchange
//
//  Created by Nikolai on 05/03/2026.
//

import UIKit

final class AmountTextField: UITextField {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupStyle() {
        placeholder = "0"
        font = AppStyle.Typography.body
        textColor = AppStyle.Color.textPrimary

        // Keyboard
        keyboardType = .decimalPad
        textAlignment = .right

        // Correction
        autocorrectionType = .no
        spellCheckingType = .no

        // TextField Style
        borderStyle = .none
        
        // Content Size
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        
        if result {
            let end = self.endOfDocument
            self.selectedTextRange = self.textRange(from: end, to: end)
        }
        
        return result
    }
}

// MARK: - AmountTextField UITextFieldDelegate -

extension AmountTextField: UITextFieldDelegate {

    // Remove Formatting during Editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = AmountParser.getRawValue(from: textField.text)
    }
    
    // Add Formatting after Editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let decimal = AmountParser.parse(textField.text) else { return }
        
        textField.text = decimal.toCurrency()
    }

    // Validation
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Allow Deletion (backspace)
        if string.isEmpty { return true }
        
        let currentText = textField.text ?? ""
        let separator = Locale.current.decimalSeparator ?? "."
        
        // Replace with Locale Separator
        let replacement = (string == "." || string == ",") ? separator : string
        
        // Create Range
        guard let swiftRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: swiftRange, with: replacement)
        
        // Auto-replace to "0" + separator
        if updatedText == separator {
            textField.text = "0" + separator
            
            return false
        }
        
        // Only Numbers + Separator
        let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: separator))
        if replacement.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return false
        }

        // Validation
        let isValid = AmountParser.isValid(updatedText)
        
        // Replaced Separator
        if isValid && replacement != string {
            textField.text = updatedText
            
            return false
        }
        
        return isValid
    }
}

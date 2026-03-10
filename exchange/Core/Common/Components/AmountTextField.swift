//
//  AmountTextField.swift
//  exchange
//
//  Created by Nikolai on 05/03/2026.
//

import UIKit

final class AmountTextField: UITextField {
    
    private enum InputLimits {
        static let maxDigitsBeforeSeparator = 7 // 1_000_000
        static let maxDigitsAfterSeparator = 2
    }
    
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
    
    // Formatting after Editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let decimal = AmountParser.parse(textField.text) else { return }
        
        textField.text = decimal.toCurrency()
    }

    // Validation
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty { return true }

        let separator = Locale.current.decimalSeparator ?? "."
        let currentText = textField.text ?? ""

        // Auto-replace to "0" + separator
        if (string == "." || string == separator) && currentText.isEmpty {
            textField.text = "0" + separator
            return false
        }

        guard let swiftRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: swiftRange, with: string)

        // Validating Raw String (without grouping)
        let escapedSeparator = NSRegularExpression.escapedPattern(for: separator)
        
        let pattern = "^[0-9]{0,\(InputLimits.maxDigitsBeforeSeparator)}(\(escapedSeparator)[0-9]{0,\(InputLimits.maxDigitsAfterSeparator)})?$"
        
        return updatedText.range(of: pattern, options: .regularExpression) != nil
    }
}


import UIKit

protocol InputPhoneViewDelegate: AnyObject {
    func inputPhoneView(didEnter number: String)
    func inputPhoneView(didBeginEditing: Void)
    func inputPhoneView(didEndEditing: Void)
}

extension InputPhoneViewDelegate {
    func inputPhoneView(didEnter number: String) {}
    func inputPhoneView(didBeginEditing: Void) {}
    func inputPhoneView(didEndEditing: Void) {}
}

final class InputPhoneView: UIView {
    
    //MARK: - Outlets & Properties
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var textField: UITextField!
    
    @IBInspectable var text: String? {
        get {
            guard
                let text = textField.text,
                !text.isEmpty
            else {
                return nil
            }
            return text
        }
        set {
            textField.text = newValue
            checkClosedState()
        }
    }
    
    var isEditing: Bool {
        get {
            textField.isEditing || textField.isFirstResponder
        }
    }
    
    var isError: Bool = false
    
    weak var delegate: InputPhoneViewDelegate?
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    //MARK: - Functions
    private func initialSetup() {
        contentView = loadNib()
        backgroundColor = .clear
        addSubview(contentView)
        setupNibConstraints(contentView)
        setNeedsLayout()
        
        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.inputAccessoryView = createNumberPadToolbar()
        titleLabel.text = "Phone number"
        
        let tapMainView = UITapGestureRecognizer(target: self, action: #selector(startEditing))
        mainView.addGestureRecognizer(tapMainView)
    }
    
    func createNumberPadToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.isTranslucent = true
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        toolbar.items = [flexibleSpace, doneButton]
        
        return toolbar
    }
    
    private func checkClosedState() {
        if (text ?? "").isEmpty {
            textField.isHidden = true
            titleLabel.font = UIFont(name: "Chalkboard SE", size: 16)
        } else {
            textField.isHidden = false
            titleLabel.font = UIFont.init(name: "Chalkboard SE", size: 14)
        }
    }
    
    private func setState(isEdit: Bool) {
        if isEdit {
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.mainView.borderColor = .black
                self?.titleLabel.textColor = .lightGray
                self?.textField.isHidden = false
                self?.titleLabel.font = UIFont.init(name: "Chalkboard SE", size: 14)
                self?.layoutIfNeeded()
            }
        }
        else {
            UIView.animate(withDuration: 0.4) { [weak self] in
                if self?.isError == true {
                    self?.mainView.borderColor = .red
                    self?.titleLabel.textColor = .red
                } else {
                    self?.mainView.borderColor = .systemGray5
                    self?.titleLabel.textColor = .lightGray
                }
                self?.checkClosedState()
                self?.layoutIfNeeded()
            }
        }
    }
    
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        let digits = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        let maxLength = 12
        let limitedDigits = String(digits.prefix(maxLength))
        
        let formattedNumber: String
        if limitedDigits.count > 3 {
            let areaCodeEndIndex = limitedDigits.index(limitedDigits.startIndex, offsetBy: 3)
            let areaCode = limitedDigits[..<areaCodeEndIndex]
            let restOfNumber = limitedDigits[areaCodeEndIndex...]
            formattedNumber = "+\(areaCode) \(restOfNumber)"
        } else {
            formattedNumber = "+\(limitedDigits)"
        }
        
        return formattedNumber
    }
    
    func showError() {
        mainView.borderColor = .red
        titleLabel.textColor = .red
        isError = true
    }
    
    func hideError() {
        if isEditing {
            mainView.borderColor = .black
        } else {
            mainView.borderColor = .systemGray5
        }
        
        titleLabel.textColor = .lightGray
        isError = false
    }
    
    @objc private func doneButtonTapped() {
        endEditing(true)
    }
    
    @objc func startEditing() {
        textField.becomeFirstResponder()
    }
    
}

extension InputPhoneView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.inputPhoneView(didBeginEditing: ())
        setState(isEdit: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.inputPhoneView(didEndEditing: ())
        setState(isEdit: false)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        hideError()
        
        let currentText = (textField.text ?? "") as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        let formattedText = formatPhoneNumber(updatedText)
        textField.text = formattedText
        
        delegate?.inputPhoneView(didEnter: formattedText)
        return false
    }
    
}

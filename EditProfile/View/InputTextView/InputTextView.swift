
import UIKit

protocol InputTextViewDelegate: AnyObject {
    func inputTextView(inputView: InputTextView, rowDidPick row: Int, value: Any)
    func inputTextView(inputView: InputTextView, willStartEditing: Void)
    func inputTextView(inputView: InputTextView, didBeginEditing: Void)
    func inputTextView(inputView: InputTextView, didEndEditing: Void)
    func inputTextView(inputView: InputTextView, textFieldShouldReturn: Void)
    func inputTextView(inputView: InputTextView, saveText: String)
    func inputTextView(inputView: InputTextView, textChanged: String)
    func inputTextView(inputView: InputTextView, dateDidPick: Date)
}

extension InputTextViewDelegate {
    func inputTextView(inputView: InputTextView, rowDidPick row: Int, value: Any) {}
    func inputTextView(inputView: InputTextView, willStartEditing: Void) {}
    func inputTextView(inputView: InputTextView, didBeginEditing: Void) {}
    func inputTextView(inputView: InputTextView, didEndEditing: Void) {}
    func inputTextView(inputView: InputTextView, textFieldShouldReturn: Void) {}
    func inputTextView(inputView: InputTextView, saveText: String) {}
    func inputTextView(inputView: InputTextView, textChanged: String) {}
    func inputTextView(inputView: InputTextView, dateDidPick: Date) {}
}

final class InputTextView: UIView {
    
    enum InputType: Int {
        case noType = 0
        
        case email = 1
        case fullName = 2
        case userName = 3
        case gender = 4
        case birthday = 5
    }
    
    //MARK: - Outlets & Properties
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var datePicker: UIDatePicker?
    private var pickerView: UIPickerView?
    
    @IBInspectable var viewType: Int {
        get {
            return self.type.rawValue
        }
        set {
            self.type = InputType(rawValue: newValue)
            self.setupUIForType(inputViewType: self.type)
        }
    }
    
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
    
    var type: InputType! = .noType
    var isError: Bool = false
    var isCanEditing = true
    var isUserName: Bool = false
    var shouldCheckSpecialSymbols: Bool = false
    var pickerData: [Any] = []
    
    var isEditing: Bool {
        get {
            textField.isEditing || textField.isFirstResponder
        }
    }
    
    weak var delegate: InputTextViewDelegate?
    
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
        
        setupUIForType(inputViewType: type)
        let tapMainView = UITapGestureRecognizer(target: self, action: #selector(startEditing))
        mainView.addGestureRecognizer(tapMainView)
    }
    
    private func textFieldSetup() {
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.textAlignment = .natural
        textField.returnKeyType = .done
        textField.inputView = nil
        textField.isSecureTextEntry = false
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
    
    private func checkClosedState() {
        if (text ?? "").isEmpty {
            textField.isHidden = true
            titleLabel.font = UIFont(name: "Chalkboard SE", size: 16)
        } else {
            textField.isHidden = false
            titleLabel.font = UIFont.init(name: "Chalkboard SE", size: 14)
        }
    }
    
    private func getPickerTitle(row: Int) -> String? {
        return (pickerData[row] as? GenderType)?.title()
    }
    
    func setupUIForType(inputViewType: InputType) {
        self.type = inputViewType
        
        switch type! {
        case .noType:
            titleLabel.text = "!!! TYPE NOT SELECTED !!!"
            
        case .email:
            titleLabel.text = "Email"
            textField.keyboardType = .emailAddress
            textField.textContentType = .emailAddress
            textField.autocapitalizationType = .none
            textFieldSetup()
            
        case .fullName:
            titleLabel.text = "Full name"
            textField.keyboardType = .default
            textField.autocapitalizationType = .sentences
            textFieldSetup()
            
        case .userName:
            titleLabel.text = "User name"
            textField.keyboardType = .default
            textField.autocapitalizationType = .none
            textFieldSetup()
            
        case .gender:
            titleLabel.text = "Gender"
            pickerData = GenderType.allCases
            pickerView = .init()
            pickerView?.delegate = self
            pickerView?.dataSource = self
            textField.inputView = pickerView
            
        case .birthday:
            titleLabel.text = "Birthday"
            datePicker = .init()
            datePicker?.preferredDatePickerStyle = .wheels
            datePicker?.datePickerMode = .date
            datePicker?.maximumDate = Date()
            datePicker?.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
            textField.inputView = datePicker
        }
    }
    
    func setSelectedRow(_ row: Int?) {
        guard let row = row else { return }
        pickerView?.selectRow(row, inComponent: 0, animated: true)
        textField.text = getPickerTitle(row: row)
        checkClosedState()
    }
    
    func getDate() -> Date? {
        guard let text = textField.text, !text.isEmpty else {
            return nil
        }
        return datePicker?.date
    }
    
    func endEditing() {
        textField.resignFirstResponder()
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
    
    func getEmail() -> String? {
        if Validator.isValidEmail(email: text ?? "") {
            return text
        } else {
            return nil
        }
    }
    
    func setDate(date: Date) {
        datePicker?.date = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let formattedDate = dateFormatter.string(from: date)
        textField.text = formattedDate
        checkClosedState()
    }
    
    @objc func startEditing() {
        textField.becomeFirstResponder()
    }
    
    @objc private func dateChanged(_ datePicker: UIDatePicker) {
        setDate(date: datePicker.date)
        delegate?.inputTextView(inputView: self, dateDidPick: datePicker.date)
    }
    
}

extension InputTextView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.inputTextView(inputView: self, willStartEditing: ())
        
        switch type {
        case .noType:
            return isCanEditing
        default:
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isUserName {
            if textField.text?.isEmpty == false && textField.text?.first != "@" {
                textField.text = "@"
            } else if textField.text?.isEmpty == true {
                textField.text = "@"
            }
        }
        
        delegate?.inputTextView(inputView: self, didBeginEditing: ())
        setState(isEdit: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setState(isEdit: false)
        delegate?.inputTextView(inputView: self, didEndEditing: ())
        delegate?.inputTextView(inputView: self, saveText: text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.inputTextView(inputView: self, textFieldShouldReturn: ())
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        hideError()
        
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        switch type {
        case .noType:
            return false
            
        default:
            if isUserName {
                if range.location == 0 && range.length > 0 {
                    return false
                }
                
                if string.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines) != nil {
                    return false
                }
                
                if shouldCheckSpecialSymbols {
                    let allowedCharacterSet = CharacterSet.letters
                    let invalidCharacters = CharacterSet(charactersIn: result).subtracting(allowedCharacterSet)
                    guard invalidCharacters.isEmpty else {
                        return false
                    }
                    
                    delegate?.inputTextView(inputView: self, textChanged: result)
                    return true
                }
                
                delegate?.inputTextView(inputView: self, textChanged: result)
                return true
            }
            
            if range.location == 0 {
                let newString = (textField.text as? NSString)?.replacingCharacters(in: range, with: string) as? NSString
                guard newString?.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0 else {
                    return false
                }
                if shouldCheckSpecialSymbols {
                    let allowedCharacterSet = CharacterSet.letters
                    let invalidCharacters = CharacterSet(charactersIn: result).subtracting(allowedCharacterSet)
                    guard invalidCharacters.isEmpty else {
                        return false
                    }
                    
                    delegate?.inputTextView(inputView: self, textChanged: result)
                    return true
                }
                
                delegate?.inputTextView(inputView: self, textChanged: result)
                return true
            }
            
            if shouldCheckSpecialSymbols {
                let allowedCharacterSet = CharacterSet.letters.union(.whitespaces)
                let invalidCharacters = CharacterSet(charactersIn: result).subtracting(allowedCharacterSet)
                
                guard invalidCharacters.isEmpty else {
                    return false
                }
                
                delegate?.inputTextView(inputView: self, textChanged: result)
                return true
            }
            
            delegate?.inputTextView(inputView: self, textChanged: result)
            return true
        }
    }
    
}

extension InputTextView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getPickerTitle(row: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        hideError()
        textField.text = getPickerTitle(row: row)
        delegate?.inputTextView(inputView: self, rowDidPick: row, value: pickerData[row])
    }
    
}

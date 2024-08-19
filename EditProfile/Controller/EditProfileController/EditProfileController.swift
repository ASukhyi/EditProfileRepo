//
//  EditProfileController.swift
//  EditProfile
//
//  Created by Andrii on 8/17/24.
//

import UIKit
import PhotosUI

protocol EditProfileControllerDelegate: AnyObject {
    func editProfile(didUpdate user: UserModel)
}

class EditProfileController: UIViewController {
    
    //MARK: - Outlets & Properties
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var avatarView: AvatarView!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var userNameField: InputTextView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var phoneNumberField: InputPhoneView!
    @IBOutlet private weak var fullNameField: InputTextView!
    @IBOutlet private weak var emailField: InputTextView!
    @IBOutlet private weak var genderField: InputTextView!
    @IBOutlet private weak var birthdayField: InputTextView!
    @IBOutlet private weak var buttonBottomConstr: NSLayoutConstraint!
    
    @IBOutlet private weak var buttonStackView: UIStackView!
    @IBOutlet private weak var saveButton: UIButton!
    
    private var datePicker: UIDatePicker?
    private var user: UserModel?
    private var userNew: UserModel?
    weak var delegate: EditProfileControllerDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarView.roundAvatar()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Functions
    private func initialSetup() {
        avatarView.delegate = self
        fullNameField.delegate = self
        emailField.delegate = self
        phoneNumberField.delegate = self
        userNameField.delegate = self
        userNameField.isUserName = true
        birthdayField.delegate = self
        genderField.delegate = self
        fullNameField.shouldCheckSpecialSymbols = true
        configureNavigation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setup()
    }
    
    private func setup() {
        guard let user: UserModel = CoreDataManager.shared.model(id: 0) else  {
            return
        }
        userNew = user
        
        fullNameLabel.text = user.fullName
        userNameLabel.text = user.userName
        avatarView.setup(img: user.profileImage ?? UIImage())
        fullNameField.text = user.fullName
        phoneNumberField.text = user.phoneNumber
        genderField.setSelectedRow(GenderType.allCases.firstIndex(where: { $0 == user.gender }))
        birthdayField.setDate(date: user.dateOfBirth ?? Date())
        emailField.text = user.email
        userNameField.text = user.userName
    }
    
    private func configureNavigation() {
        navigationItem.title = "Edit Profile"
        navigationController?.setCustomBackButton(for: self, target: self, backAction: #selector(goBack))
        navigationController?.setCustomTitleFont(font: UIFont.systemFont(ofSize: 22, weight: .bold))
    }
    
    private func showGaleryPermissionAlertToSettings() {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { [weak self] _ in
            self?.goToSettings()
        }
        
        let alert = UIAlertController(title: "Access Photo Gallery", message:  "This app needs access to your Photo Gallery to function properly. Please grant permission in the Settings", preferredStyle: .alert)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func uploadPhoto() {
        PermissionService.requestPhotoLibraryAccess() { [weak self] status in
            DispatchQueue.main.async { [weak self] in
                guard let self else {return}
                if status {
                    self.openPHPickerModule(delegate: self, filter: .images, limit: 1)
                } else {
                    self.showGaleryPermissionAlertToSettings()
                }
            }
        }
    }
    
    private func goToSettings() {
        guard let settingsURL: URL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settingsURL)
    }
    
    private func updateUserData() {
        if user != userNew {
            guard let userNew else {
                return
            }
            CoreDataManager.shared.updateModel(updatedUser: userNew)
            delegate?.editProfile(didUpdate: userNew)
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func isImageSizeValid(image: UIImage) -> Bool {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return false
        }
        let imageSizeInMB = Double(imageData.count) / (1024.0 * 1024.0)
        return imageSizeInMB <= 2.0
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Image Size Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        let keyboardHeightFull: CGFloat = keyboardFrame.cgRectValue.height
        let buttonHeight = buttonStackView.frame.height
        let fullHeight = keyboardHeightFull + buttonHeight
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.layoutSubviews]) { [weak self] in
            self?.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: fullHeight, right: 0)
            self?.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: fullHeight, right: 0)
            self?.buttonBottomConstr.constant = keyboardHeightFull -  (self?.view.safeAreaInsets.bottom ?? 0)
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.layoutSubviews]) { [weak self] in
            self?.buttonBottomConstr.constant = 0
            self?.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self?.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self?.view.layoutIfNeeded()
        }
    }
    
    @IBAction private func didSave(_ sender: Any) {
        view.endEditing(true)
        
        if userNew?.fullName == nil {
            fullNameField.showError()
            return
        }
        
        if emailField.getEmail() == nil {
            emailField.showError()
            return
        }
        
        if (userNew?.userName?.count ?? 0) < 2 || userNew?.userName?.first != "@" {
            userNameField.showError()
            return
        }
        
        var textNumber = userNew?.phoneNumber
        textNumber?.removeFirst()
        let stringWithoutSpaces = textNumber?.replacingOccurrences(of: " ", with: "")
        
        if stringWithoutSpaces?.isNumeric() == false || stringWithoutSpaces?.isEmpty == true {
            phoneNumberField.showError()
            return
        }
        
        let age = Calendar.current.dateComponents([.year], from: userNew?.dateOfBirth ?? Date(), to: Date()).year ?? 0
        if age < 18 {
            birthdayField.showError()
            return
        }
        
        updateUserData()
    }
    
}

extension EditProfileController: InputTextViewDelegate {
    
    func inputTextView(inputView: InputTextView, textChanged: String) {
        switch inputView {
        case fullNameField:
            userNew?.fullName = textChanged.isEmpty ? nil : textChanged
            
        case emailField:
            userNew?.email = textChanged.isEmpty ? nil : textChanged
            
        case userNameField:
            userNew?.userName = textChanged.isEmpty ? nil : textChanged
            
        default:
            break
        }
    }
    
    func inputTextView(inputView: InputTextView, dateDidPick: Date) {
        if inputView == birthdayField {
            userNew?.dateOfBirth = dateDidPick
        }
    }
    
    func inputTextView(inputView: InputTextView, rowDidPick row: Int, value: Any) {
        if inputView == genderField {
            guard let gender = value as? GenderType else { return }
            userNew?.gender = gender
        }
    }
    
    func inputTextView(inputView: InputTextView, textFieldShouldReturn: Void) {
        view.endEditing(true)
    }
    
}

extension EditProfileController: AvatarViewDelegate {
    
    func avatarView(_ view: AvatarView, photoButtonDidTap: Void) {
        uploadPhoto()
    }
    
}

extension EditProfileController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        
        guard results.isEmpty == false else {
            return
        }
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
                if let image = object as? UIImage {
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        if isImageSizeValid(image: image) {
                            userNew?.profileImage = image
                            avatarView.setup(img: image)
                        } else {
                            showAlert(message: "Image size exceeds 2MB.")
                        }
                    }
                }
            }
        }
    }
    
}

extension EditProfileController: InputPhoneViewDelegate {
    
    func inputPhoneView(didEnter number: String) {
        userNew?.phoneNumber = number.isEmpty ? nil : number
    }
    
}

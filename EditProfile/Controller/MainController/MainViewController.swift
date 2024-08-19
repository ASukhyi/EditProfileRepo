//
//  ViewController.swift
//  EditProfile
//
//  Created by Andrii on 8/16/24.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Outlets & Properties
    @IBOutlet private weak var avatarView: AvatarView!
    @IBOutlet private weak var fullName: UILabel!
    
    let router: MainRouter = .init()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarView.roundAvatar()
    }

    //MARK: - Functions
    private func initialSetup() {
        router.viewController = self
        checkIfUserCreated()
    }
    
    private func checkIfUserCreated() {
        if let user: UserModel = CoreDataManager.shared.model(id: 0) {
            setupUser(user: user)
        } else {
            let user: UserModel = .init(
                id: 0,
                fullName: "Alvaro Morata",
                gender: .male,
                profileImage: UIImage(named: "avatar"),
                phoneNumber: "+111 111111111",
                email: "test@gmail.com",
                userName: "@userName",
                dateOfBirth: Calendar.current.date(byAdding: .year, value: -20, to: Date())
            )
            user.mapToEntity()
            CoreDataManager.shared.saveIfNeeded()
            setupUser(user: user)
        }
    }
    
    private func setupUser(user: UserModel) {
        fullName.text = user.fullName
        avatarView.setup(img: user.profileImage ?? UIImage())
    }
    
    @IBAction private func didTapEdit(_ sender: Any) {
        router.showEditProfile(delegate: self)
    }
    
}

extension MainViewController:  EditProfileControllerDelegate {
    
    func editProfile(didUpdate user: UserModel) {
        setupUser(user: user)
    }
    
}


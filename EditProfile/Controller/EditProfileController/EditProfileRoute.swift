//
//  EditProfileRoute.swift
//  EditProfile
//
//  Created by Andrii on 8/17/24.
//

import UIKit

protocol EditProfileRoute {
    func configureEditProfile(delegate: EditProfileControllerDelegate?) -> EditProfileController
}

extension EditProfileRoute {
    
    func configureEditProfile(
        delegate: EditProfileControllerDelegate?
    ) -> EditProfileController {
        
        let editProfileController: EditProfileController = UIStoryboard.storyboardMain.instantiateViewController(ofType: EditProfileController.self)
        editProfileController.delegate = delegate
        
        return editProfileController
    }
    
}

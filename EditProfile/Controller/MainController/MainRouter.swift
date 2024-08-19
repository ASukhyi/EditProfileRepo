//
//  MainRouter.swift
//  EditProfile
//
//  Created by Andrii on 8/17/24.
//

import UIKit

class MainRouter: BaseRouter, MainRouter.Routes {
    
    typealias Routes = EditProfileRoute
    
    func showEditProfile(delegate: EditProfileControllerDelegate?) {
        let editProfile = configureEditProfile(
            delegate: delegate
        )
        
        viewController?.navigationController?.pushViewController(editProfile, animated: true)
    }
    
}

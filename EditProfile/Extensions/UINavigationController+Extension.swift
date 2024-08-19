//
//  UINavigationController+Extension.swift
//  EditProfile
//
//  Created by Andrii on 8/17/24.
//

import UIKit

extension UINavigationController {
    
    func setCustomBackButton(for viewController: UIViewController, target: Any?, backAction: Selector) {
        let backButton = BackButtonView()
        backButton.addTarget(target, action: backAction, for: .touchUpInside)
        let item: UIBarButtonItem = .init(customView: backButton)
        viewController.navigationItem.leftBarButtonItem = item
    }
    
    func setCustomTitleFont(font: UIFont) {
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: font
        ]
    }
    
}

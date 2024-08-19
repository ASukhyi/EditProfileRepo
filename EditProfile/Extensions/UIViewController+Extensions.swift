//
//  UIViewController+Extensions.swift
//  EditProfile
//
//  Created by Andrii on 8/18/24.
//

import UIKit
import PhotosUI

extension UIViewController {
    
    func openPHPickerModule(
        delegate: PHPickerViewControllerDelegate?,
        filter: PHPickerFilter? = .images,
        limit: Int
    ) {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = limit
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = delegate
        picker.modalTransitionStyle = .coverVertical
        picker.modalPresentationStyle = .overFullScreen
        present(picker, animated: true)
    }
    
}

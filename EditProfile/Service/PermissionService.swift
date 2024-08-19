//
//  PermissionService.swift
//  EditProfile
//
//  Created by Andrii on 8/18/24.
//

import Foundation
import Photos

class PermissionService {
    
    private init() {}
    
    static func requestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            completion(true)
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized)
                }
            }
            
        case .denied, .restricted, .limited:
            completion(false)
            
        @unknown default:
            completion(false)
        }
    }
    
}

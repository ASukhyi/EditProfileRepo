//
//  UserModel.swift
//  EditProfile
//
//  Created by Andrii on 8/18/24.
//

import UIKit

public struct UserModel: Equatable, Coredatable {
    public typealias ModelType = UserModelEntity
    
    var id: Int
    var fullName: String?
    var gender: GenderType?
    var profileImage: UIImage?
    var phoneNumber: String?
    var email: String?
    var userName: String?
    var dateOfBirth: Date?
    
    @discardableResult
    public func mapToEntity() -> UserModelEntity {
        UserModelEntity.init(
            fullName: fullName,
            gender: gender,
            profileImage: profileImage,
            phoneNumber: phoneNumber,
            email: email,
            userName: userName,
            dateOfBirth: dateOfBirth,
            id: id
        )
    }
    
}

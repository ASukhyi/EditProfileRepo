//
//  UserModelEntity+CoreDataClass.swift
//  EditProfile
//
//  Created by Andrii on 8/18/24.
//
//

import UIKit
import CoreData

@objc(UserModelEntity)
public class UserModelEntity: NSManagedObject, Domainable {
    public typealias ModelType = UserModel
    
    convenience init(
        fullName: String?,
        gender: GenderType?,
        profileImage: UIImage?,
        phoneNumber: String?,
        email: String?,
        userName: String?,
        dateOfBirth: Date?,
        id: Int
    ) {
        self.init(context: CoreDataManager.shared.context)
        self.fullName = fullName
        self.gender = Int16(gender?.rawValue ?? 0)
        self.profileImage = profileImage?.pngData() ?? UIImage().pngData()
        self.phoneNumber = phoneNumber
        self.email = email
        self.userName = userName
        self.dateOfBirth = dateOfBirth
        self.id = Int16(id)
        
    }
    
    public func mapToModel() -> UserModel {
        UserModel.init(
            id: Int(id),
            fullName: fullName,
            gender: GenderType(rawValue: Int(gender)),
            profileImage: profileImage.flatMap { UIImage(data: $0) },
            phoneNumber: phoneNumber,
            email: email,
            userName: userName,
            dateOfBirth: dateOfBirth
        )
    }
    
}

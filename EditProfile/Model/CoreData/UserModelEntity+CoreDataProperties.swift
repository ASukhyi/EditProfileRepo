//
//  UserModelEntity+CoreDataProperties.swift
//  EditProfile
//
//  Created by Andrii on 8/18/24.
//
//

import Foundation
import CoreData


extension UserModelEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserModelEntity> {
        return NSFetchRequest<UserModelEntity>(entityName: "UserModelEntity")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var gender: Int16
    @NSManaged public var profileImage: Data?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var email: String?
    @NSManaged public var userName: String?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var id: Int16

}

extension UserModelEntity : Identifiable {

}

//
//  Domainable.swift
//  EditProfile
//
//  Created by Andrii on 8/18/24.
//

import Foundation
import CoreData

public protocol Domainable where Self: NSManagedObject {
    associatedtype ModelType
    
    func mapToModel() -> ModelType
}

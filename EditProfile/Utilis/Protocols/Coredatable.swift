//
//  Coredatable.swift
//  EditProfile
//
//  Created by Andrii on 8/18/24.
//

import Foundation

public protocol Coredatable {
    associatedtype ModelType: Domainable
    
    @discardableResult
    func mapToEntity() -> ModelType
}

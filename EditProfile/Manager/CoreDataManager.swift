//
//  CoreDataManager.swift
//  EditProfile
//
//  Created by Andrii on 8/18/24.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EditProfile")
        container.loadPersistentStores { description, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            container.viewContext.mergePolicy = NSOverwriteMergePolicy
        }
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {}
    
    func model<T: Coredatable>(id: Int) -> T? {
        let request: NSFetchRequest<T.ModelType> = .init(entityName: String(describing: T.ModelType.self))
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %d", id)
        
        return object(request: request)?.mapToModel() as? T
    }
    
    func updateModel(updatedUser: UserModel) {
        guard let object: UserModelEntity = object(id: updatedUser.id) else {
            return
        }
        object.fullName = updatedUser.fullName
        object.gender = Int16(updatedUser.gender?.rawValue ?? 0)
        object.profileImage = updatedUser.profileImage?.pngData() ?? UIImage().pngData()
        object.phoneNumber = updatedUser.phoneNumber
        object.email = updatedUser.email
        object.userName = updatedUser.userName
        object.dateOfBirth = updatedUser.dateOfBirth
        
        saveIfNeeded()
    }
    
    func object<T: Domainable>(id: Int) -> T? {
        let request: NSFetchRequest<T> = .init(entityName: String(describing: T.self))
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %d", id)
        
        return object(request: request)
    }
    
    func object<T>(request: NSFetchRequest<T>) -> T? {
        do {
            let result = try context.fetch(request)
            let model: T? = result.first
            return model
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    @discardableResult
    func saveIfNeeded() -> Bool {
        guard context.hasChanges else {
            return false
        }
        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}



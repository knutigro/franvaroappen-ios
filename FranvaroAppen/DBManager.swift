//
//  DBManager.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2018-08-28.
//  Copyright © 2018 Knut Inge Grosland. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol ChildPersistenceProtocol {
    
    func fetchAllChildren(completion: @escaping ([Child], NSError?) -> Void)
    func fetchChild(withName name: String, completion: @escaping (Child?, NSError?) -> Void)
    func delete(child: Child)
    func save(child: Child, withChild oldChild: Child?, image: UIImage?, completion: @escaping (Child?, NSError?) -> Void)
}

class DBManager: ChildPersistenceProtocol {
    
    let kChildEntity = "ChildEntity"
    
    fileprivate lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "FranvaroAppen")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension DBManager {
    
    internal func fetchAllChildEntities(completion: @escaping ([NSManagedObject], NSError?) -> Void) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: kChildEntity)
        do {
            if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                completion(results, nil)
            }
        } catch let error as NSError {
            completion([NSManagedObject](), error)
        }
    }
    
    internal func fetchAllChildren(completion: @escaping ([Child], NSError?) -> Void) {
        fetchAllChildEntities { (results, error) in
            let children = results.map { Child(managedObject: $0) }
            completion(children, error)
        }
    }
    
    internal func fetchChildEntity(withName name: String, completion: @escaping (NSManagedObject?, NSError?) -> Void) {
        fetchAllChildEntities { (object, error) in
            let childObject = object.filter({ (object) -> Bool in
                Child(managedObject: object).name == name
            }).first
            completion(childObject, error)
        }
    }
    
    internal func fetchChild(withName name: String, completion: @escaping (Child?, NSError?) -> Void) {
        fetchChildEntity(withName: name) { (object, error) in
            guard let child = object else {
                completion(nil, error)
                return
            }
            completion(Child(managedObject: child), error)
        }
    }
    
    internal func delete(child: Child) {
        fetchChildEntity(withName: child.name) { [weak self] (object, error) in
            guard let managedContext = self?.persistentContainer.viewContext, let childEntity = object else { return }
            do {
                managedContext.delete(childEntity)
                try managedContext.save()
            } catch let error as NSError  {
                print("Kunde inte radera \(error), \(error.userInfo)")
            }
        }
    }
    
    internal func createChild(completion: @escaping (NSManagedObject?, NSError?) -> Void) {
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: kChildEntity, in: managedContext)!
        let childEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        completion(childEntity, nil)
    }

    internal func fetchOrCreateChildEntity(child: Child?, completion: @escaping (NSManagedObject?, NSError?) -> Void) {
        
        guard let child = child else {
            createChild(completion: completion)
            return
        }
        
        fetchChildEntity(withName: child.name) { [weak self] (object, error) in
            guard let child = object else {
                self?.createChild(completion: completion)
                return
            }
            completion(child, error)
        }
    }
    
    internal func save(child: Child, withChild oldChild: Child? = nil, image: UIImage? = nil, completion: @escaping (Child?, NSError?) -> Void) {
        
        fetchOrCreateChildEntity(child: oldChild) { [weak self] (object, error) in
            guard let childEnity = object else {
                completion(nil, NSError(domain: "DBManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Kunde inte spara"]))
                return
            }

            childEnity.setValue(child.name, forKey: "name")
            childEnity.setValue(child.personalNumber, forKey: "personal_number")
            if let image = image {
                childEnity.setValue(image.jpegData(compressionQuality: 1), forKey: "photo")
            }
            
            do {
                let managedContext = self?.persistentContainer.viewContext
                try managedContext?.save()
                completion(Child(managedObject: childEnity), nil)
            } catch let error as NSError  {
                completion(nil, error)
            }
        }
    }
}

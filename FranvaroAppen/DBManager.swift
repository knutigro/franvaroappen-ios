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

class DBManager {
    
    lazy var persistentContainer: NSPersistentContainer = {
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
    
    func fetchAllChildren(completion: @escaping ([NSManagedObject], NSError?) -> Void) {
        
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChildEntity")
        do {
            if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                completion(results, nil)
            }
        } catch let error as NSError {
            completion([NSManagedObject](), error)
        }
    }
    
    func fetchChild(withName name: String, completion: @escaping (NSManagedObject?, NSError?) -> Void) {
        fetchAllChildren { (object, error) in
            
            let childObject = object.filter({ (object) -> Bool in
                Child.newWith(managedObject: object).name == name
            }).first
            
            completion(childObject, error)
        }
    }
    
    func delete(child: NSManagedObject) {
        let managedContext = persistentContainer.viewContext
        
        do {
            managedContext.delete(child)
            try managedContext.save()
        } catch let error as NSError  {
            print("Kunde inte radera \(error), \(error.userInfo)")
        }
    }
    
    func save(child: Child, image: UIImage?, previousObject: NSManagedObject? = nil, completion: @escaping (NSManagedObject?, NSError?) -> Void) {
        
        let managedContext = persistentContainer.viewContext
 
        var childEntity = previousObject
        if childEntity == nil {
            let entity = NSEntityDescription.entity(forEntityName: "ChildEntity", in: managedContext)!
            childEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        }
        
        guard let childEnity = childEntity else {
            completion(nil, NSError(domain: "DBManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Kunde inte spara"]))
            return
        }
        
        childEnity.setValue(child.name, forKey: "name")
        childEnity.setValue(child.personalNumber, forKey: "personal_number")
        if let image = image {
            childEnity.setValue(image.jpegData(compressionQuality: 1), forKey: "photo")
        }
        
        do {
            try managedContext.save()
            completion(childEnity, nil)
        } catch let error as NSError  {
            completion(nil, error)
        }
    }
}

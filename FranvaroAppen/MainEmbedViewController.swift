//
//  MainEmbedViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-10.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit
import CoreData

class MainEmbedViewController: EmbedViewController, SegueHandlerType {
    
    enum SegueIdentifier: String {
        case EmbedMenu = "EmbedMenu"
        case EmbedChildSelect = "EmbedChildSelect"
        case EmbedAddChild = "EmbedAddChild"
    }
    
    var children = [NSManagedObject]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segueIdentifierForSegue(segue) {
        case .EmbedMenu:
            if let controller = segue.destination as? MenuViewController {
                self.title = "Lägg till barn"
                if let child = children.first {
                    controller.child = Child.newWith(managedObject: child)
                }
            }
        case .EmbedChildSelect:
            if let controller = segue.destination as? ChildListViewController {
                self.title = "Välj barn"
            }
        case .EmbedAddChild:
            if let controller = segue.destination as? EditChildViewController {
                self.title = "Lägg till barn"
            }
        }
    }

    func updateData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChildEntity")
        do {
            if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                children = results
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        updateUI()
    }
    
    func updateUI() {
        if children.count == 1 {
            performSegueWithIdentifier(.EmbedMenu, sender: self)
        } else if children.count > 1 {
            performSegueWithIdentifier(.EmbedChildSelect, sender: self)
        } else {
            performSegueWithIdentifier(.EmbedAddChild, sender: self)
        }
    }

}



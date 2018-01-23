//
//  ChildListViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-10.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

class ChildListViewController: UITableViewController, SegueHandlerType {
    
    var children = [NSManagedObject]()
    var viewControllerIsFirstTimeLoading = true
    
    enum SegueIdentifier: String {
        case OpenAddChild = "OpenAddChild"
        case OpenAddChildNoAnimation = "OpenAddChildNoAnimation"
        case OpenChildMenu = "OpenChildMenu"
        case OpenChildMenuNoAnimation = "OpenChildMenuNoAnimation"
    }

    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.title = NSLocalizedString("Barn", comment: "")
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        updateData()
        
        if children.count == 0 {
            performSegueWithIdentifier(.OpenAddChildNoAnimation, sender: nil)
        } else if children.count == 1 {
            performSegueWithIdentifier(.OpenChildMenuNoAnimation, sender: children.first)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil, queue: nil) { [weak self] note in
            DispatchQueue.main.async(execute: { [weak self] () in
                self?.updateData()
            });
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewControllerIsFirstTimeLoading {
            viewControllerIsFirstTimeLoading = false
        } else {
            updateData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(screen: "Child list")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue) {
        case .OpenAddChild, .OpenAddChildNoAnimation:
            if let controller = segue.destination as? EditChildViewController {
                controller.title = NSLocalizedString("Lägg till barn", comment: "")
            }
        case .OpenChildMenu, .OpenChildMenuNoAnimation:
            if let controller = segue.destination as? MenuViewController {
                controller.childEntity = sender as? NSManagedObject
            }
        }
    }
    
    func updateData() {
        guard let managedContext = AppDelegate.originalAppDelegate?.persistentContainer.viewContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChildEntity")
        do {
            if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                children = results
                
                let childrenNames = children.map{Child.newWith(managedObject: $0).name} as NSArray
                if (childrenNames.count > 0) {
                    Analytics.trackValue(value: childrenNames, forProfileAttribute: "Children")
                }
                Analytics.trackValue(value: NSNumber(integerLiteral: childrenNames.count), forProfileAttribute: "Number of children")
                
                tableView.reloadData()
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}

// MARK: UITableViewDataSource

extension ChildListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return children.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChildCell") as! ChildCell
        let child = children[indexPath.row]
        
        cell.update(child: Child.newWith(managedObject: child))
        
        return cell
    }
}

// MARK: CoreData

extension ChildListViewController {
    
    func delete(child: NSManagedObject) {
        guard let managedContext = AppDelegate.originalAppDelegate?.persistentContainer.viewContext else {
            return
        }
        do {
            managedContext.delete(child)
            try managedContext.save()
        } catch let error as NSError  {
            print("Kunde inte radera \(error), \(error.userInfo)")
        }
    }
}


// MARK: TableViewDelegate

extension ChildListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegueWithIdentifier(.OpenChildMenu, sender: children[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let child = children[indexPath.row]
        let delete = UITableViewRowAction(style: .normal, title: "Radera") { [weak self] action, index in
            self?.delete(child: child)
        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
}

// MARK: DZNEmptyDataSetSource

extension ChildListViewController: DZNEmptyDataSetSource {
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString {
        return NSAttributedString(string: NSLocalizedString("Lägg till barn", comment: ""), attributes: [NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 24)])
    }
}

// MARK: DZNEmptyDataSetDelegate

extension ChildListViewController: DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView) {
        performSegueWithIdentifier(.OpenAddChild, sender: self)
    }
}



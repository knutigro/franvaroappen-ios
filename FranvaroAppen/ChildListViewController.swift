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
    
    enum SegueIdentifier: String {
        case OpenAddChild = "OpenAddChild"
        case OpenEditChild = "OpenEditChild"
    }

    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue) {
        case .OpenAddChild:
            if let controller = segue.destination as? EditChildViewController {
                controller.title = "Lägg till barn"
            }
        case .OpenEditChild:
            if let controller = segue.destination as? EditChildViewController {
                controller.title = "Ändra barn"
                controller.childEntity = sender as? NSManagedObject
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            managedContext.delete(child)
            try managedContext.save()
        } catch let error as NSError  {
            print("Kunde inte radera \(error), \(error.userInfo)")
        }
        updateData()
    }
}


// MARK: TableViewDelegate

extension ChildListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegueWithIdentifier(.OpenEditChild, sender: children[indexPath.row])
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
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString {
        return NSAttributedString(string: "Ingen barn")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString {
        return NSAttributedString(string: "Lägg till barn", attributes: [NSForegroundColorAttributeName:UIColor.black,
                                                                                                               NSFontAttributeName: UIFont.systemFont(ofSize: 22)])
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



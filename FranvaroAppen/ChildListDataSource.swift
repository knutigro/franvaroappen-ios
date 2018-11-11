//
//  ChildListDataSource.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2018-10-30.
//  Copyright © 2018 Knut Inge Grosland. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import RxSwift
import RxCocoa

class ChildListDataSource: NSObject, UITableViewDataSource {

    var disposeBag = DisposeBag()
    var models = Variable<[Child]>([])
    var childPersistenceController: ChildPersistenceProtocol

    init(childPersistenceController: ChildPersistenceProtocol) {
        self.childPersistenceController = childPersistenceController
        super.init()
        
        NotificationCenter.default.rx
            .notification(NSNotification.Name.NSManagedObjectContextObjectsDidChange)
            .subscribe(onNext: { [weak self ] _ in
                DispatchQueue.main.async(execute: { () in
                    self?.update()
                });
            })
            .disposed(by: disposeBag)
    }

    func update() {
        childPersistenceController.fetchAllChildren(completion: { [weak self] (objects, error) in
            if let error = error {
                print("Could not fetch \(error), \(error.userInfo)")
                return
            }
            self?.models.value = objects
        })
    }
    
    func delete(atIndexPath indexPath: IndexPath) {
        let child = models.value[indexPath.row]
        childPersistenceController.delete(child: child)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChildCell") as! ChildCell
        let child = models.value[indexPath.row]
        cell.update(child: child)
        
        return cell
    }
}

// MARK: DZNEmptyDataSetSource

extension ChildListDataSource: DZNEmptyDataSetSource {
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString {
        return NSAttributedString(string: NSLocalizedString("Lägg till barn", comment: ""), attributes: [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)])
    }
}


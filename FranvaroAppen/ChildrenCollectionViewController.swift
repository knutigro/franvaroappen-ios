//
//  ChildrenCollectionViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-10.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit
import CoreData

class ChildrenCollectionViewController: UICollectionViewController {
    
    let kContentOffset: CGFloat = 10.0
    let kNumberOfItemsPerPage: CGFloat = 2.0
    
    var itemSize: CGSize {
        let totalWidth = collectionView?.bounds.size.width ?? 0
        let height = collectionView != nil ? collectionView!.bounds.size.height - (kContentOffset * 2) : 0
        let itemWidth = (totalWidth / kNumberOfItemsPerPage) - (kNumberOfItemsPerPage * kContentOffset)
        return CGSize(width: itemWidth, height: height)
    }
    
    var viewHeight: CGFloat {
        return itemSize.height + (2 * kContentOffset)
    }
    
    var children = [Child]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateData()
    }
    
    func updateData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChildEntity")
        do {
            if let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                children = results.map({ (managedObject) -> Child in
                    return Child.newWith(managedObject: managedObject)
                })
                collectionView?.reloadData()
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension ChildrenCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return children.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChildGridCell", for: indexPath) as! ChildGridCell
        cell.setup(child: children[indexPath.item])

        return cell
    }
}

extension ChildrenCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
}

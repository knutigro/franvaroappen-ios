//
//  Child.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-09.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit
import CoreData

struct Child {
    
    var name: String
    var personalNumber: String
    var image: UIImage?
}

extension Child {
    
    static func newWith(managedObject: NSManagedObject) -> Child {
        let name = managedObject.value(forKey: "name") as? String ?? ""
        let personalNumber = managedObject.value(forKey: "personal_number") as? String ?? ""
        var image: UIImage?
        if let imageData = managedObject.value(forKey: "photo") as? Data {
            image = UIImage(data: imageData)
        }
    
        return Child(name: name, personalNumber: personalNumber, image: image)
    }
}



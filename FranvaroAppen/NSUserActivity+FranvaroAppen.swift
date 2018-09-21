//
//  NSUserActivity+FranvaroAppen.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2018-08-27.
//  Copyright © 2018 Knut Inge Grosland. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices
//import Intents

enum UserActivityType: String {
    case composeMessage = "com.cocmoc.franvaro.compose-message"
    case reportSickleave = "com.cocmoc.franvaro.report-sickleave"
    case reportAbsence = "com.cocmoc.franvaro.report-absence"
}

extension NSUserActivity {
    
    fileprivate static var childrenNameKey: String { return "userName" }

    var childrenName: String? {
        set {
            if (userInfo == nil) { userInfo = [AnyHashable: Any]()  }
            userInfo?[NSUserActivity.childrenNameKey] = newValue
        }
        get {
            return userInfo?[NSUserActivity.childrenNameKey] as? String
        }
    }
    
    convenience init(type: UserActivityType) {
        self.init(activityType: type.rawValue)
    }
    
    convenience init(type: UserActivityType, description: String) {
        self.init(type: type)
        isEligibleForSearch = true
        requiredUserInfoKeys = [NSUserActivity.childrenNameKey]
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        let image = UIImage(named: "Icon-76")!
        attributes.thumbnailData = UIImagePNGRepresentation(image)
        attributes.contentDescription = description
        contentAttributeSet = attributes
        if #available(iOS 12, *) {
            isEligibleForPrediction = true
        }
    }

}

protocol ChildController: NSUserActivityDelegate {
    var child: Child? { get set }
    func updateUserActivity(userActivity: NSUserActivity, with child: Child)
}

extension ChildController where Self: UIViewController, Self: NSUserActivityDelegate {
    
    func updateUserActivity(userActivity: NSUserActivity, with child: Child) {
        userActivity.keywords = [child.name, "Frånvaro", "Anmäl"]
        userActivity.title = child.name
        userActivity.childrenName = child.name
        if #available(iOS 12, *) {
            userActivity.persistentIdentifier = NSUserActivityPersistentIdentifier(format: "%@-%@", userActivity.activityType, child.name)
        }
    }
}


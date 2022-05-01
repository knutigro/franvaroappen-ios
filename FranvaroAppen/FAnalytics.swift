//
//  Analytics.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-12.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import Foundation
import FirebaseAnalytics

struct FAnalytics {
    
    // Keys
    static let kSMSCategoryKey = "Category"
    static let kResultKey = "Result"
    static let kErrorKey = "Error"
    static let kNumberOfSmsSentKey = "Number of SMS"
    static let kLocationKey = "Location"

    // Events
    static let kRatingDialogEvent = "Rate app dialog"
    static let kDidTapReviewCellEvent = "Tapped review app cell"
    static let kShareButtonTappedEvent = "Tapped share button"

    // Enums
    enum MessageComposeResult : String {
        case cancelled = "cancelled"
        case sent = "sent"
        case failed = "failed"
    }

    enum Result: String {
        case success = "Success"
        case fail = "Fail"
    }
    
    static func autoIntegrate(_ launchOptions: [AnyHashable: Any]?) {
    }
    
    static func track(event: String, attributes: [String: String]? = nil) {
        Analytics.logEvent(event, parameters: attributes)
    }

    static func trackValue(value: NSObject, forProfileAttribute: String) {
        #warning("DEACTIVATED")
//        Analytics.logEvent(event, parameters: attributes)
//        Localytics.setValue(value, forProfileAttribute: forProfileAttribute)
    }

    static func incrementValue(by value: Int, forProfileAttribute attribute: String) {
#warning("DEACTIVATED")

//        Localytics.incrementValue(by: value, forProfileAttribute: attribute)
    }
    
    static func track(screen: String) {
#warning("DEACTIVATED")

//        Localytics.tagScreen(screen)
    }
}

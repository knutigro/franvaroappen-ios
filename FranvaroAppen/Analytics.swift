//
//  Analytics.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-12.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import Foundation
import Localytics

struct Analytics {
    
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
        #if DEBUG
        #else
            Localytics.autoIntegrate("c37149f6da0bce9e37c3180-b7ca7ba8-a91e-11e6-67f0-007933b47d84", launchOptions: launchOptions)
        #endif
    }
    
    static func track(event: String) {
        Analytics.track(event: event, attributes: nil)
    }
    
    static func track(event: String, attributes: [String: String]?) {
        Localytics.tagEvent(event, attributes: attributes)
    }

    static func trackValue(value: NSObject, forProfileAttribute: String) {
        Localytics.setValue(value, forProfileAttribute: forProfileAttribute)
    }

    static func incrementValue(by value: Int, forProfileAttribute attribute: String) {
        Localytics.incrementValue(by: value, forProfileAttribute: attribute)
    }
    
    static func track(screen: String) {
        Localytics.tagScreen(screen)
    }
}

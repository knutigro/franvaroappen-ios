//
//  Analytics.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-12.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import Foundation
import Localytics

extension Dictionary where Key == Analytics.AttributesKey, Value == String {
    func mapKeys() -> Dictionary<String, String> {
        var newDict = Dictionary<String, String>()
        keys.forEach { (key) in
            newDict[key.rawValue] = self[key]
        }
        return newDict
    }
}

struct Analytics {

    enum Screen : String {
        case childList = "Child list"
        case menu = "Menu"
        case editChild = "Edit child"
        case sendInfo = "Send Info"
        case sms = "Sms"
        case report = "Report"
        case aboutSms = "About sms"
        case aboutApp = "About app"
    }

    enum SMSCategory : String {
        case message = "Message"
        case sickLeave = "Sick Leave"
        case absence = "Absence"
    }

    enum AttributesKey : String {
        case SMSCategory = "Category"
        case result = "Result"
        case error = "Error"
        case location = "Location"
    }
    
    enum ProfileAttributesKey : String {
        case image = "Image"
        case numberOfSmsSent = "Number of SMS"
        case children = "Children"
        case numberOfChildren = "Number of children"
    }
    
    enum Event: String {
        case ratingDialog = "Rate app dialog"
        case didTapReviewCell = "Tapped review app cell"
        case didTapShareButton = "Tapped share button"
        case didSendSMS = "Did send sms"
        case facebookMessage = "Facebook message"
        case facebookShare = "Facebook share"
        case facebookError = "Facebook error"
    }

    enum MessageComposeResult: String {
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
            if let key = Secrets.localyticsAPIKey {
                Localytics.autoIntegrate(key, launchOptions: launchOptions)
            }
        #endif
    }
    
    static func track(event: Event) {
        Analytics.track(event: event, attributes: nil)
    }
    
    static func track(event: Event, attributes: [AttributesKey: String]?) {
        Localytics.tagEvent(event.rawValue, attributes: attributes?.mapKeys())
    }

    static func trackValue(value: NSObject, forProfileAttribute: ProfileAttributesKey) {
        Localytics.setValue(value, forProfileAttribute: forProfileAttribute.rawValue)
    }

    static func incrementValue(by value: Int, forProfileAttribute attribute: ProfileAttributesKey) {
        Localytics.incrementValue(by: value, forProfileAttribute: attribute.rawValue)
    }
    
    static func track(screen: Screen) {
        Localytics.tagScreen(screen.rawValue)
    }

    static func didRequestUserNotificationAuthorization(withOptions options: UInt, granted: Bool) {
        Localytics.didRequestUserNotificationAuthorization(withOptions: options, granted: granted)
    }
}

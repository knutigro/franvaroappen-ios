//
//  RatingManager.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2017-04-01.
//  Copyright © 2017 Knut Inge Grosland. All rights reserved.
//

import Foundation
import StoreKit

let kFirstUseDate = "FirstUseDate"
let kUseCount = "UseCount"
let kSignificantEventCount = "SignificantEventCount"
let kCurrentVersion = "CurrentVersion"
let kDidShowRatingPromtForCurrentVersion = "DidShowRatingPromtForCurrentVersion"
let kUserDidTapReviewLink = "UserDidTapReviewLink"

class RatingManager {
    
    static var debug = false
    static var daysUntilPromt = 0
    static var usesUntilPromt = 0
    static var significantEventsUntilPrompt = 0
    static var shouldPromtOnlyOncePerVersion = false

    class var shouldRequestReview: Bool {
        if (RatingManager.debug) { return true }
        if (isTimingToNearFirstUse) { return false }
        if (isUseCounterTooSmall) { return false }
        if (isSignificantEventsTooSmall) { return false }
        if (didShowRatingPromtForCurrentVersion) { return false }
        
        return true
    }

    public class var firstLaunchDate: Date {
        return Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: kFirstUseDate))
    }
    
    public class var useCount: Int {
        return UserDefaults.standard.integer(forKey: kUseCount)
    }

    public class var significantEventCount: Int {
        return UserDefaults.standard.integer(forKey: kSignificantEventCount)
    }

    public class var didShowRatingPromtForCurrentVersion: Bool {
        return UserDefaults.standard.bool(forKey: kDidShowRatingPromtForCurrentVersion)
    }

    public class var didTapReviewLink: Bool {
        get {
            return UserDefaults.standard.bool(forKey: kUserDidTapReviewLink)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kUserDidTapReviewLink)
            _save()
        }
    }

    private class var isUseCounterTooSmall: Bool {
        return useCount < usesUntilPromt
    }
    
    public class var lastTrackedVersion: String? {
        return UserDefaults.standard.string(forKey: kCurrentVersion)
    }
    
    private class var currentVersion: String {
        return Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? ""
    }

    private class var isSignificantEventsTooSmall: Bool {
        return significantEventCount < significantEventsUntilPrompt
    }
    
    private class var isTimingToNearFirstUse: Bool {
        let timeSinceFirstLaunch = Date().timeIntervalSince(firstLaunchDate)
        let timeUntilRate = Double(60 * 60 * 24 * daysUntilPromt)
        
        return timeSinceFirstLaunch < timeUntilRate
    }
    
    class func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
            if (shouldPromtOnlyOncePerVersion) {
                UserDefaults.standard.set(true, forKey: kDidShowRatingPromtForCurrentVersion)
            }
            _save()
        }
    }
    
    class func appLaunched() {
        if (_versionCheck().isNew) {
            _setFirstUseDate()
            _incrementUseCount()
        } else {
            // it's a new version of the app, so restart tracking
            resetTracking()
        }
        _save()
    }

    class func userDidSignificantEvent() {
        _incrementSignificantEventCount()
        _save()
    }
    
    private class func _save() {
        UserDefaults.standard.synchronize()
    }
    
    private class func _versionCheck() -> (version: String, isNew: Bool)  {
        let currentVersion = self.currentVersion
        var lastTrackedVersion = self.lastTrackedVersion
        
        if (lastTrackedVersion == nil) {
            lastTrackedVersion = currentVersion
            UserDefaults.standard.set(currentVersion, forKey: kCurrentVersion)
        }
        let isNew = lastTrackedVersion == currentVersion
        return (currentVersion, isNew)

    }
    
    private class func _incrementUseCount() {
        let userDefaults = UserDefaults.standard
        var useCount = userDefaults.integer(forKey: kUseCount)
        useCount = useCount + 1
        userDefaults.set(useCount, forKey: kUseCount)
    }

    private class func _incrementSignificantEventCount() {
        let userDefaults = UserDefaults.standard
        var useCount = userDefaults.integer(forKey: kSignificantEventCount)
        useCount = useCount + 1
        userDefaults.set(useCount, forKey: kSignificantEventCount)
    }

    private class func _setFirstUseDate() {
        let userDefaults = UserDefaults.standard
        var timeInterval = userDefaults.double(forKey: kFirstUseDate)
        
        if (timeInterval == 0) {
            timeInterval = Date().timeIntervalSince1970
            userDefaults.set(timeInterval, forKey: kFirstUseDate)
        }
    }
    
    public class func resetTracking() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(currentVersion, forKey: kCurrentVersion)
        userDefaults.set(false, forKey: kDidShowRatingPromtForCurrentVersion)
        userDefaults.set(Date().timeIntervalSince1970, forKey: kFirstUseDate)
        userDefaults.set(0, forKey: kUseCount)
        userDefaults.set(0, forKey: kSignificantEventCount)
    }
}

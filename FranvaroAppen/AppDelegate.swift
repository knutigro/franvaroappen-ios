//
//  AppDelegate.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-09.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var originalAppDelegate:AppDelegate!
    
    var dbManager = DBManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppDelegate.originalAppDelegate = self
        
        Theme.applyTheme(window: window)
        
        FirebaseApp.configure()
        
        RatingManager.daysUntilPromt = 5
        RatingManager.significantEventsUntilPrompt = 3
        RatingManager.daysUntilPromt = 5
        RatingManager.shouldPromtOnlyOncePerVersion = true
        RatingManager.appLaunched()

        application.registerForRemoteNotifications()
        
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
        }
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        dbManager.saveContext()
    }
    
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        guard let type = UserActivityType(rawValue: userActivity.activityType) else { return false }
        guard let name = userActivity.childrenName else { return false }
        guard let viewController = window?.rootViewController else { return false }
        
        let approuter = ApplicationRouter(viewController: viewController)
        
        var fetchedChild: Child?
        dbManager.fetchChild(withName: name) { (object, error) in
            guard let object = object else { return }
            fetchedChild = Child(managedObject: object)
        }

        guard let child = fetchedChild else { return false }

        switch type {
        case .composeMessage:
            approuter.presentSendInfoViewController(with: child, animated: false)
            return true
        case .reportSickleave:
            approuter.presentReportSickLeaveViewController(with: child, animated: false)
            return true
        case .reportAbsence:
            approuter.presentReportAbsenceViewController(with: child, animated: false)
            return true
        }
    }
}

//
//  Theme.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-11.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit

class Theme {
    
    class func applyTheme(window: UIWindow?) {
        
        UINavigationBar.appearance().barTintColor = UIColor.App.blue
        UINavigationBar.appearance().tintColor = UIColor.App.blue

        if #available(iOS 13.0, *) {
            if let navigationController = window?.rootViewController as? UINavigationController {
                    let appearance = UINavigationBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    appearance.backgroundColor = UIColor.white
                    appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.App.blue]
                    navigationController.navigationBar.standardAppearance = appearance
                    navigationController.navigationBar.scrollEdgeAppearance = navigationController.navigationBar.standardAppearance
                navigationController.navigationBar.barTintColor = UIColor.App.blue
            }
        }

        // Changing the navigation controller's title colour
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.App.blue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        
        UIBarButtonItem.appearance().setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.App.blue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], for: .normal)
    }
}

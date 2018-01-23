//
//  Theme.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-11.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit

class Theme {
    
    class func applyTheme() {
        
        // Changing the status bar's colour to white
        UIApplication.shared.statusBarStyle = .default
        
        // Changing the colour of the bar button items
        UINavigationBar.appearance().tintColor = UIColor.App.blue
        
        // Changing the navigation controller's background colour
        UINavigationBar.appearance().barTintColor = UIColor.white
        
        // Changing the navigation controller's title colour
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.App.blue, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)]
        
        UIBarButtonItem.appearance().setTitleTextAttributes( [NSAttributedStringKey.foregroundColor: UIColor.App.blue, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)], for: .normal)
    }
}

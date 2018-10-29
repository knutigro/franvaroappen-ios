//
//  Secrets.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2018-10-29.
//  Copyright © 2018 Knut Inge Grosland. All rights reserved.
//

import Foundation

class Secrets {
    
    private class var keys: NSDictionary {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") {
            return NSDictionary(contentsOfFile: path) ?? [:]
        }
        return [:]
    }
    
    public class var localyticsAPIKey: String? {
        return Secrets.keys["Localytics"] as? String
    }
}

//
//  Storyboard.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2018-10-30.
//  Copyright © 2018 Knut Inge Grosland. All rights reserved.
//

import UIKit

extension UIViewController {
    public static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

public enum Storyboard: String {
    
    case main = "Main"
    
    public func instantiate<VC: UIViewController>(_ viewController: VC.Type, indentifier: String = VC.storyboardIdentifier, inBundle bundle: Bundle = Bundle.main) -> VC {
        guard let vc = UIStoryboard(name: self.rawValue, bundle: bundle).instantiateViewController(withIdentifier: indentifier) as? VC else {
            fatalError("Could't instantiatiate \(VC.storyboardIdentifier) from \(self.rawValue)")
        }
        
        return vc
    }
    
    public func instantiateInitialViewController<VC: UIViewController>(_ viewController: VC.Type, inBundle bundle: Bundle = Bundle.main) -> VC {
        guard let vc = UIStoryboard(name: self.rawValue, bundle: bundle).instantiateInitialViewController() as? VC else {
            fatalError("Could't instantiatiate \(VC.storyboardIdentifier) from \(self.rawValue)")
        }
        
        return vc
    }
}

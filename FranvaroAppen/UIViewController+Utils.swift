//
//  UIViewController+Utils.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-09.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit

/**
 A protocol specific to the Lister sample that represents the segue identifier
 constraints in the app. Every view controller provides a segue identifier
 enum mapping. This protocol defines that structure.
 
 We also want to provide implementation to each view controller that conforms
 to this protocol that helps box / unbox the segue identifier strings to
 segue identifier enums. This is provided in an extension of `SegueHandlerType`.
 */
public protocol SegueHandlerType {
    
    /**
     Gives structure to what we expect the segue identifiers will be. We expect
     the `SegueIdentifier` mapping to be an enum case to `String` mapping.
     
     For example:
     
     enum SegueIdentifier: String {
     case ShowAccount = "ShowAccount"
     case ShowHelp    = "ShowHelp"
     ...
     }
     */
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    /**
     An overload of `UIViewController`'s `performSegueWithIdentifier(_:sender:)`
     method that takes in a `SegueIdentifier` enum parameter rather than a
     `String`.
     */
    public func performSegueWithIdentifier(_ segueIdentifier: Self.SegueIdentifier, sender: AnyObject?) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
    }
    
    /**
     A convenience method to map a `StoryboardSegue` to the  segue identifier
     enum that it represents.
     */
    public func segueIdentifierForSegue(_ segue: UIStoryboardSegue) -> Self.SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier \(segue.identifier)")
        }
        
        return segueIdentifier
    }
}

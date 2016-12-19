//
//  ShareManager.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-12-08.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit

class ShareManager: NSObject {
    
    func openShareSelector(style: UIAlertControllerStyle, viewController: UIViewController, barButton: UIBarButtonItem) {
        
        let alert = UIAlertController(title: NSLocalizedString("Facebook", comment: ""), message:nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Skicka appen till vänner", comment: ""), style: UIAlertActionStyle.default, handler:  { [weak self](action) in
            Analytics.track(event: Analytics.kShareButtonTappedEvent, attributes: [Analytics.kResultKey: "Message on Facebook", Analytics.kLocationKey: String(describing: type(of: viewController))])
            self?.sendMessageOnFacebook()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dela appen på Facebook", comment: ""), style: UIAlertActionStyle.default, handler:  { [weak self](action) in
            Analytics.track(event: Analytics.kShareButtonTappedEvent, attributes: [Analytics.kResultKey: "Share on Facebook", Analytics.kLocationKey: String(describing: type(of: viewController))])
            self?.shareOnFacebook(viewController: viewController)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.default, handler: {(action) in
            Analytics.track(event: Analytics.kShareButtonTappedEvent, attributes: [Analytics.kResultKey: "Cancelled", Analytics.kLocationKey: String(describing: type(of: viewController))])
        }))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.barButtonItem = barButton
        }

        viewController.present(alert, animated: true, completion: nil)
    }
    
    func shareLinkContent() -> FBSDKShareLinkContent {
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "https://itunes.apple.com/us/app/anmal-franvaro-lidkoping/id1175852934") as URL!
        content.contentTitle = NSLocalizedString("Anmäl frånvaro Lidköping", comment: "")
        content.contentDescription = NSLocalizedString("Nu kan du enkelt anmäla frånvaro för barn i Lidköpings kommunala förskolor och fritids. Med några klick registrerar du som vårdnadshavare heldag eller del av dag då ditt barn är frånvarande. Appen genererar sedan din anmälan i form av ett sms som skickas till Lidköping kommuns e-tjänster.", comment: "")
        content.imageURL = NSURL(string: "http://knutigro.github.io/documents/franvaro/facebook_add.jpg") as URL!
        
        return content
    }
    
    func shareOnFacebook(viewController: UIViewController){
        let dialog : FBSDKShareDialog = FBSDKShareDialog()
        dialog.mode = .native
        dialog.fromViewController = viewController
        dialog.delegate = self
        let shareContent = shareLinkContent()
        dialog.shareContent = shareContent
        
        if !dialog.canShow() {
            dialog.mode = .browser
        }
        dialog.show()
    }
    
    func sendMessageOnFacebook() {
        let dialog : FBSDKMessageDialog = FBSDKMessageDialog()
        dialog.delegate = self
        dialog.shareContent = shareLinkContent()
        
        if dialog.canShow() {
            dialog.show()
        } else {
            // Messenger isn't installed. Redirect the person to the App Store.
            UIApplication.shared.open(NSURL(string: "https://itunes.apple.com/se/app/messenger/id454638411?mt=8") as! URL, options: [:], completionHandler: nil)
        }
    }
}

// MARK: FBSDKSharingDelegate

extension ShareManager: FBSDKSharingDelegate {
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        Analytics.track(event: facebookEvent(results: results), attributes: [Analytics.kResultKey: Analytics.Result.success.rawValue])
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        Analytics.track(event: "Facebook error", attributes: [Analytics.kResultKey: Analytics.Result.fail.rawValue, Analytics.kErrorKey: error.localizedDescription])
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        Analytics.track(event: "Facebook error", attributes: [Analytics.kResultKey: Analytics.Result.fail.rawValue, Analytics.kErrorKey: "Cancelled by user"])
    }
    
    func facebookEvent(results: [AnyHashable : Any]!) -> String {
        if let completionGesture = results["completionGesture"] as? String, completionGesture == "message" {
            return "Facebook message"
        } else {
            return "Facebook share"
        }
    }
}

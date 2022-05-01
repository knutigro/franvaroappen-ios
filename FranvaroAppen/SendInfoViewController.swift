//
//  SendInfoViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-09.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import Foundation
import MessageUI

class SendInfoViewController: UIViewController, ChildController {
    
    let limit = 160
    @IBOutlet var textViewBottomContraint: NSLayoutConstraint?
    @IBOutlet weak var textView: UITextView?
    @IBOutlet weak var textLimitLabel: UILabel?
    var child: Child?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Skicka information", comment: "")
        
        textView?.becomeFirstResponder()
        textView?.text = ""
        
        assert(child != nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        textLimitLabel?.text = String(format: "%i / %i", textView?.text.count ?? 0, limit)
        
        userActivity = NSUserActivity(type: .composeMessage, description: "Skicka information")
        userActivity?.delegate = self
        userActivity?.becomeCurrent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FAnalytics.track(screen: "Send Info")
    }
    
    @objc func keyboardWillChangeFrame(aNotification:NSNotification) {
        let info = aNotification.userInfo
        let infoNSValue = info![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let duration = aNotification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        let kbSize = infoNSValue.cgRectValue.size
        let newHeight = kbSize.height
        textViewBottomContraint?.constant = newHeight + 8
        view.setNeedsLayout()
        UIView.animate(withDuration: duration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    @IBAction func didTapSendButton(_ objects: AnyObject?) {
        let message = textView?.text ?? ""
        guard let  personalNumber = child?.personalNumber else {
            assertionFailure()
            return;
        }
        
        guard !message.isEmpty else {
            let alert = UIAlertController(title: NSLocalizedString("Fel", comment: ""),
                                          message: NSLocalizedString("Medelandet kan inte vara tomt", comment: ""),
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)

            return
        }
        
        if (MFMessageComposeViewController.canSendText()) {
            FAnalytics.track(screen: "Sms")

            let controller = MFMessageComposeViewController()
            controller.body = MessageHelper.messageForInformation(personalNumber: personalNumber, message: message)
            controller.recipients = [MessageHelper.PhoneNumber]
            controller.messageComposeDelegate = self
            present(controller, animated: true, completion: nil)
        }
    }
}

extension SendInfoViewController: MFMessageComposeViewControllerDelegate {
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        var res = ""
        switch result {
        case .cancelled:
            res = FAnalytics.MessageComposeResult.cancelled.rawValue
            break
        case .failed:
            res = FAnalytics.MessageComposeResult.failed.rawValue
            break
        case .sent:
            res = FAnalytics.MessageComposeResult.sent.rawValue
            break
        }
        
        FAnalytics.track(event: "Did send sms", attributes: [FAnalytics.kResultKey: res, FAnalytics.kSMSCategoryKey: "Message"])
        
        if (result == .sent) {
            RatingManager.userDidSignificantEvent()
            FAnalytics.incrementValue(by: 1, forProfileAttribute: FAnalytics.kNumberOfSmsSentKey)
        }
        
        self.dismiss(animated: true, completion:nil)
    }
}

// MARK: UITextViewDelegate

extension SendInfoViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.length + range.location > (textView.text?.count ?? 0) { return false  }
        
        let newLength = textView.text.count + text.count - range.length
        
        textLimitLabel?.text = String(format: "%i / %i", min(newLength, limit), limit)

        return newLength <= limit
    }
}

// MARK: NSUserActivityDelegate

extension SendInfoViewController: NSUserActivityDelegate {
    
    @objc func userActivityWillSave(_ userActivity: NSUserActivity) {
        if let child = child {
            updateUserActivity(userActivity: userActivity, with: child)
        }
    }
}



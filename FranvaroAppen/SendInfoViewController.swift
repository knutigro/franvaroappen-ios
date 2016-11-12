//
//  SendInfoViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-09.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import Foundation
import MessageUI

class SendInfoViewController: UIViewController {
    
    let limit = 160
    @IBOutlet var textViewBottomContraint: NSLayoutConstraint?
    @IBOutlet weak var textView: UITextView?
    @IBOutlet weak var textLimitLabel: UILabel?
    var child: Child?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView?.becomeFirstResponder()
        textView?.text = ""
        
        assert(child != nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        textLimitLabel?.text = String(format: "%i / %i", textView?.text.characters.count ?? 0, limit)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(screen: "Send Info")
    }
    
    func keyboardWillChangeFrame(aNotification:NSNotification) {
        let info = aNotification.userInfo
        let infoNSValue = info![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let kbSize = infoNSValue.cgRectValue.size
        let newHeight = kbSize.height
        textViewBottomContraint?.constant = newHeight + 8
    }
    
    @IBAction func didTapSendButton(_ objects: AnyObject?) {
        
        let message = textView?.text ?? ""
        guard let  personalNumber = child?.personalNumber else {
            assertionFailure()
            return;
        }
        
        guard !message.isEmpty else {
            let alert = UIAlertController(title: "Fel",
                                          message: "Medelandet kan inte vara tomt",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)

            return
        }
        
        if (MFMessageComposeViewController.canSendText()) {
            Analytics.track(screen: "Sms")

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
            res = Analytics.MessageComposeResult.cancelled.rawValue
            break
        case .failed:
            res = Analytics.MessageComposeResult.failed.rawValue
            break
        case .sent:
            res = Analytics.MessageComposeResult.sent.rawValue
            break
        }
        
        Analytics.track(event: "Did send sms", attributes: [Analytics.kResultKey: res])
        
        self.dismiss(animated: true, completion:nil)
    }
}

// MARK: UITextViewDelegate

extension SendInfoViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.length + range.location > (textView.text?.characters.count ?? 0) { return false  }
        
        let newLength = textView.text.characters.count + text.characters.count - range.length
        
        textLimitLabel?.text = String(format: "%i / %i", min(newLength, limit), limit)

        return newLength <= limit
    }
}

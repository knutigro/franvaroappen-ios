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
    
    @IBOutlet weak var textView: UITextView?
    var child: Child?

    override func viewDidLoad() {
        super.viewDidLoad()
        textView?.becomeFirstResponder()
        textView?.text = ""
        
        assert(child != nil)
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
        self.dismiss(animated: true, completion:nil)
    }
}

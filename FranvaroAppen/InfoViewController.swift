//
//  InfoViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-11.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView?
    @IBOutlet weak var actInd: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Om sms tjänsten", comment: "")
        
        if let pdfURL = Bundle.main.url(forResource: "info", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            webView?.loadRequest(URLRequest(url: pdfURL))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(screen: .aboutSms)
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        actInd?.stopAnimating()
    }
}

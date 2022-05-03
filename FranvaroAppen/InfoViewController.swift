//
//  InfoViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-11.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit
import WebKit

class InfoViewController: UIViewController, UIWebViewDelegate {
    
    lazy var webView: WKWebView = {
        let webViewConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        return webView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = webView

        title = NSLocalizedString("Om sms tjänsten", comment: "")
        
        if let pdf = Bundle.main.url(forResource: "info", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = URLRequest(url: pdf)
            webView.load(req)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FAnalytics.track(screen: "About sms")
    }

}

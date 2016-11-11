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
        
        if let pdf = Bundle.main.url(forResource: "info", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(url: pdf)
            webView?.loadRequest(req as URLRequest)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        actInd?.stopAnimating()
    }
}

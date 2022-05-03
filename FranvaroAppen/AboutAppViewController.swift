//
//  AboutAppViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-12-06.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit
import SafariServices

class AboutAppViewController: UIViewController {
    
    @IBOutlet weak var infoTextView: UITextView?
    @IBOutlet weak var iconView: IconView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Om appen", comment: "")
        

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Privacy", style: .plain, target: self, action: #selector(privacyButtonTapped))
        
        infoTextView?.text = NSLocalizedString("\nDenne app är inte gjord på uppdrag av Lidköping kommun, men av en förälder som gillar att göra appar.\n\nKom gärna med tips angående förbättringar eller förslag på andra appar som behövs.\n\nKnut Inge Grösland\nhei@knutinge.com\nknutigro.github.io", comment: "")
        
        iconView?.animateDrawingPath()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FAnalytics.track(screen: "About app")
    }
    
    @objc func privacyButtonTapped() {
        
        if let url = URL(string: "http://knutigro.github.io/apps/Franvaro/privacy.html") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
        
    }

}

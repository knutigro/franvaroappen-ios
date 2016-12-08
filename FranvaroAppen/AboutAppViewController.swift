//
//  AboutAppViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-12-06.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController {
    
    @IBOutlet weak var infoTextView: UITextView?
    
    let shareManager = ShareManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Om appen", comment: "")
        
        infoTextView?.text = NSLocalizedString("\nDenne app är inte gjord på uppdrag av Lidköping kommun, men av en förälder som gillar att göra appar.\n\nKom gärna med tips angående förbättringar eller förslag på andra appar som behövs.\n\nKnut Inge Grösland\nhei@knutinge.com\nknutigro.github.io", comment: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(screen: "About app")
    }
    
    @IBAction func didTapShareButton(_ objects: AnyObject?) {
        shareManager.openShareSelector(style: .actionSheet, viewController: self)
    }
}

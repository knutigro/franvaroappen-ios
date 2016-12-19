//
//  AboutAppViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-12-06.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit
import SpriteKit

class AboutAppViewController: UIViewController {
    
    @IBOutlet weak var infoTextView: UITextView?
    @IBOutlet weak var iconView: IconView?
    @IBOutlet weak var spriteKitView: SKView?
    
    let toyScene = ToyScene()
    
    let shareManager = ShareManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Om appen", comment: "")
        
        infoTextView?.text = NSLocalizedString("\nDenne app är inte gjord på uppdrag av Lidköping kommun, men av en förälder som gillar att göra appar.\n\nKom gärna med tips angående förbättringar eller förslag på andra appar som behövs.\n\nKnut Inge Grösland\nhei@knutinge.com\nknutigro.github.io", comment: "")
        
        iconView?.animateDrawingPath()
        spriteKitView?.presentScene(toyScene)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(screen: "About app")
        toyScene.beginBubbling()
    }
    
    @IBAction func didTapShareButton(_ barButton: UIBarButtonItem) {
        shareManager.openShareSelector(style: .actionSheet, viewController: self, barButton: barButton)
    }
}

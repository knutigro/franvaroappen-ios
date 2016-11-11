//
//  EmbedViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-10.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit

class EmbedInEmbedViewControllerSegue: UIStoryboardSegue {
    override func perform() {
    }
}

class EmbedViewController: UIViewController {
    
    var currentViewController: UIViewController? {
        return self.childViewControllers.count > 0 ? self.childViewControllers[0] : nil
    }
    
    var defaultSegueIdentifier: String?
    var cacheEmbededViewControllers = false
    
    private var cachedViewControllers = [String: UIViewController]()
    private var currentSegueIdentifier: String?

    
    @IBOutlet weak var textView: UITextView?
    var child: Child?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // embed default segue
        if let defaultSegueIdentifier = defaultSegueIdentifier {
            performSegue(withIdentifier: defaultSegueIdentifier, sender: self)
        }
    }
    
    func embededViewControllerForSegueWith(identifier: String) -> UIViewController? {
        if currentSegueIdentifier == identifier {
            return currentViewController
        }
        
        return cachedViewControllers[identifier]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier != currentSegueIdentifier {
            var destinationViewController = segue.destination
            
            if cacheEmbededViewControllers { // replace segue's view controller with the cached one
                if let cachedController = embededViewControllerForSegueWith(identifier: identifier)  {
                    destinationViewController = cachedController
                }
            }
            
            swapTo(viewController: destinationViewController)
            currentSegueIdentifier = identifier
            
            if cacheEmbededViewControllers {
                cachedViewControllers[identifier] = destinationViewController;
            }
        }
    }
    
    func swapTo(viewController: UIViewController) {
        let fromViewController = currentViewController
        
        if fromViewController != nil {
            fromViewController?.view.removeFromSuperview()
            fromViewController?.willMove(toParentViewController: nil)
            fromViewController?.removeFromParentViewController()
        }
        
        
        viewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        addChildViewController(viewController)
        view?.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
}

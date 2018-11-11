//
//  ApplicationRouter.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2018-08-28.
//  Copyright © 2018 Knut Inge Grosland. All rights reserved.
//

import UIKit

class ApplicationRouter {
    
    var presentingViewController: UIViewController
    var childPersistenceController: ChildPersistenceProtocol
    
    required init(viewController: UIViewController, childPersistenceController: ChildPersistenceProtocol) {
        self.presentingViewController = viewController
        self.childPersistenceController = childPersistenceController
    }
    
    class func initialViewController(childPersistenceController: ChildPersistenceProtocol) -> UIViewController {
        let navigationController = Storyboard.main.instantiateInitialViewController(NavigationController.self)
        (navigationController.children.first as? ChildListViewController)?.childPersistenceController = childPersistenceController
        return navigationController
    }
    
    fileprivate var childListViewController: ChildListViewController {
        let controller = Storyboard.main.instantiate(ChildListViewController.self)
        controller.childPersistenceController = childPersistenceController
        return controller
    }

    fileprivate var sendInfoViewController: SendInfoViewController {
        let controller = Storyboard.main.instantiate(SendInfoViewController.self)
        controller.childPersistenceController = childPersistenceController
        return controller
    }

    fileprivate var reportViewController: ReportViewController {
        let controller = Storyboard.main.instantiate(ReportViewController.self)
        controller.childPersistenceController = childPersistenceController
        return controller
    }
    
    fileprivate var editChildViewController: EditChildViewController {
        let controller = Storyboard.main.instantiate(EditChildViewController.self)
        controller.childPersistenceController = childPersistenceController
        return controller
    }

    fileprivate var menuViewController: MenuViewController {
        let controller = Storyboard.main.instantiate(MenuViewController.self)
        controller.childPersistenceController = childPersistenceController
        return controller
    }
    
    fileprivate func present(viewController: UIViewController, animated: Bool) {
        if let navigationController = presentingViewController as? UINavigationController {
            if navigationController.children.isEmpty {
                navigationController.setViewControllers([viewController], animated: true)
            } else {
                navigationController.pushViewController(viewController, animated: animated)
            }
        } else {
            presentingViewController.present(viewController, animated: animated, completion: nil)
        }
    }

    func presentSendInfoViewController(with child: Child, animated: Bool) {
        let controller = sendInfoViewController
        controller.child =  child
        present(viewController: controller, animated: animated)
    }
    
    func presentAddChildViewController(animated: Bool) {
        let controller = editChildViewController
        controller.title = NSLocalizedString("Lägg till barn", comment: "")
        present(viewController: controller, animated: animated)
    }
    
    func presentEditChildViewController(with child: Child, delegate: EditChildViewControllerDelegate?, animated: Bool) {
        let controller = editChildViewController
        controller.child = child
        controller.delegate = delegate
        present(viewController: controller, animated: animated)
    }
    
    func presentMenuViewController(with child: Child, animated: Bool) {
        let controller = menuViewController
        controller.child = child
        present(viewController: controller, animated: animated)
    }
    
    func presentReportViewController(with child: Child, type: ReportViewController.ReportType, animated: Bool) {
        let controller = reportViewController
        controller.child = child
        controller.reportType = type
        present(viewController: controller, animated: animated)
    }
    
    func presentInfoViewController(animated: Bool) {
        let controller = Storyboard.main.instantiate(InfoViewController.self)
        present(viewController: controller, animated: animated)
    }

    func presentAboutViewController(animated: Bool) {
        let controller = Storyboard.main.instantiate(AboutAppViewController.self)
        present(viewController: controller, animated: animated)
    }
    
    func presentChildListViewController(animated: Bool) {
        present(viewController: childListViewController, animated: animated)
    }

    func presenRatingViewController() {
        UIApplication.shared.open(URL(string:"https://itunes.apple.com/se/app/anm%C3%A4l-fr%C3%A5nvaro-lidk%C3%B6ping/id1175852934?action=write-review")!, options: [:], completionHandler: nil)
    }

    func presentImagePickerController(from viewController: UIViewController, sourceView: UIView, delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate, animated: Bool) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = delegate
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            imagePicker.modalPresentationStyle = .popover
        }
        viewController.present(imagePicker, animated: animated, completion: nil)
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            let popper = imagePicker.popoverPresentationController
            popper?.sourceView = sourceView
        }
    }
}

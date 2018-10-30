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
        controller.childPersistenceController = childPersistenceController
        present(viewController: controller, animated: animated)
    }
    
    func presentReportSickLeaveViewController(with child: Child, animated: Bool) {
        let controller = reportViewController
        controller.reportType = .sickLeave
        controller.child =  child
        controller.childPersistenceController = childPersistenceController
        present(viewController: controller, animated: animated)
    }
    
    func presentReportAbsenceViewController(with child: Child, animated: Bool) {
        let controller = reportViewController
        controller.reportType = .absence
        controller.child =  child
        controller.childPersistenceController = childPersistenceController
        present(viewController: controller, animated: animated)
    }
}

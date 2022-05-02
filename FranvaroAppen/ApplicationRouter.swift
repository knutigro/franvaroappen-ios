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
    
    required init(viewController: UIViewController) {
        self.presentingViewController = viewController
    }
    
    fileprivate var storyBoard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    fileprivate var sendInfoViewController: SendInfoViewController {
        return storyBoard.instantiateViewController(withIdentifier: String(describing: SendInfoViewController.self)) as! SendInfoViewController
    }

    fileprivate var reportViewController: CreateReportViewController {
        return storyBoard.instantiateViewController(withIdentifier: String(describing: CreateReportViewController.self)) as! CreateReportViewController
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
    
    func presentReportSickLeaveViewController(with child: Child, animated: Bool) {
        let controller = reportViewController
        controller.viewModel = ReportViewModel(reportType: .sickLeave, child: child)
        present(viewController: controller, animated: animated)
    }
    
    func presentReportAbsenceViewController(with child: Child, animated: Bool) {
        let controller = reportViewController
        controller.viewModel = ReportViewModel(reportType: .absence, child: child)
        present(viewController: controller, animated: animated)
    }
}

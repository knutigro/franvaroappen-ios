//
//  CreateReportViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2022-05-02.
//  Copyright © 2022 Knut Inge Grosland. All rights reserved.
//

import UIKit
import SwiftUI
import MessageUI

class CreateReportViewController: UIViewController, ChildController {
    
    var child: Child? {
        set {
            viewModel?.child = newValue
        }
        get {
            viewModel?.child
        }
    }
    
    var viewModel: ReportViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let viewModel = self.viewModel {
            addReportView(viewModel: viewModel)
            
            switch viewModel.reportType {
            case .absence:
                title = NSLocalizedString("Ledighet", comment: "")
                userActivity = NSUserActivity(type: .reportAbsence, description: "Anmäl ledighet")
                userActivity?.delegate = self
                userActivity?.becomeCurrent()
                break
            case .sickLeave:
                title = NSLocalizedString("Sjukfrånvaro", comment: "")
                userActivity = NSUserActivity(type: .reportSickleave, description: "Anmäl sjukfrånvaro")
                userActivity?.delegate = self
                userActivity?.becomeCurrent()
                break
            }
                
        }
    }

    deinit {
    }
    
    @IBAction func didTapSendButton(_ objects: AnyObject?) {
        
        guard let viewModel = viewModel else { return }
        
        guard let personalNumber = viewModel.child?.personalNumber else {
            assertionFailure()
            return;
        }
        
        var message: String?
        
        switch viewModel.reportType {
        case .absence:
            if (viewModel.fromDate.compare(viewModel.toDate) == .orderedDescending) {
                showAlert(message: NSLocalizedString("Till måste vara efter från", comment: ""))
            } else if (!viewModel.completeDay && !NSCalendar.current.isDate(viewModel.fromDate, inSameDayAs: viewModel.toDate)) {
                showAlert(message: NSLocalizedString("Till och från måste vara samma dag om du inte anmäler heldagar", comment: ""))
            } else {
                message = MessageHelper.messageForAbsence(personalNumber: personalNumber, from: viewModel.fromDate, to: viewModel.toDate, completeDay: viewModel.completeDay)
            }

            break
        case .sickLeave:
            if (!NSCalendar.current.isDateInToday(viewModel.fromDate)) {
                showAlert(message: NSLocalizedString("Sjukfrånvaro måste anmälas samma dag", comment: ""))
            } else if (viewModel.fromDate.compare(viewModel.toDate) == .orderedDescending) {
                showAlert(message: NSLocalizedString("Till måste vara efter från", comment: ""))
            } else if (viewModel.fromDate.compare(viewModel.toDate) == .orderedSame) {
                message = MessageHelper.messageForSickLeave(personalNumber: personalNumber, from: viewModel.fromDate, to: nil)
            } else {
                message = MessageHelper.messageForSickLeave(personalNumber: personalNumber, from: viewModel.fromDate, to: viewModel.toDate)
            }
            
            break
        }
        
        guard let body = message else {
            return
        }
        
        print(body)
        
        if (MFMessageComposeViewController.canSendText()) {
            FAnalytics.track(screen: "Sms")

            let controller = MFMessageComposeViewController()
            controller.body = body
            controller.recipients = [MessageHelper.PhoneNumber]
            controller.messageComposeDelegate = self
            present(controller, animated: true, completion: nil)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

private extension CreateReportViewController {
    
    func addReportView(viewModel: ReportViewModel) {
        let reportView = ReportView(viewModel: viewModel)
        let controller = UIHostingController(rootView: reportView)
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        controller.didMove(toParent: self)

        NSLayoutConstraint.activate([
            controller.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            controller.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            controller.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controller.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension CreateReportViewController: MFMessageComposeViewControllerDelegate {
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        var res = ""
        switch result {
        case .cancelled:
            res = FAnalytics.MessageComposeResult.cancelled.rawValue
            break
        case .failed:
            res = FAnalytics.MessageComposeResult.failed.rawValue
            break
        case .sent:
            res = FAnalytics.MessageComposeResult.sent.rawValue
            break
        @unknown default:
            fatalError()
        }
        
        let category = viewModel?.reportType == ReportViewModel.ReportType.sickLeave ? "Sick Leave" : "Absence"
        
        FAnalytics.track(event: "Did send sms", attributes: [FAnalytics.kResultKey: res, FAnalytics.kSMSCategoryKey: category])

        if (result == .sent) {
            RatingManager.userDidSignificantEvent()
            FAnalytics.incrementValue(by: 1, forProfileAttribute: FAnalytics.kNumberOfSmsSentKey)
        }

        self.dismiss(animated: true, completion:nil)
    }
}

// MARK: NSUserActivityDelegate

extension CreateReportViewController: NSUserActivityDelegate {
    
    @objc func userActivityWillSave(_ userActivity: NSUserActivity) {
        if let child = viewModel?.child {
            updateUserActivity(userActivity: userActivity, with: child)
        }
    }
}

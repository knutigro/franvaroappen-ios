//
//  ReportViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-11.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import StaticDataTableViewController
import UIKit
import MessageUI

class ReportViewController: StaticDataTableViewController, SegueHandlerType {
    
    enum ReportType {
        case sickLeave
        case absence
    }
    
    enum DateSelect {
        case none
        case from
        case to
    }
    
    @IBOutlet weak var daySwitch: UISwitch?
    @IBOutlet weak var fromCell: UITableViewCell?
    @IBOutlet weak var toCell: UITableViewCell?
    @IBOutlet weak var fromLabel: UILabel?
    @IBOutlet weak var toLabel: UILabel?
    
    var child: Child?
    var reportType = ReportType.sickLeave
    var dateSelect = DateSelect.none
    
    var completeDay = true {
        didSet {
            updateUI()
        }
    }
    var fromDate = Date()
    var toDate = Date()
    
    struct DateFormatter {
        static let short: Foundation.DateFormatter = {
            let dateFormatter = Foundation.DateFormatter()
            dateFormatter.dateStyle = .short
            
            return dateFormatter
        }()
        static let withTime: Foundation.DateFormatter = {
            let dateFormatter = Foundation.DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            
            return dateFormatter
        }()
    }
    
    enum SegueIdentifier: String {
        case OpenFromDatePicker = "OpenFromDatePicker"
        case OpenToDatePicker = "OpenToDatePicker"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        fromDate = Date()
        toDate = Date()
        
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue) {
        case .OpenFromDatePicker:
            if let controller = segue.destination as? DatePickerViewController {
                dateSelect = .from
                controller.delegate = self
                controller.date = fromDate
                controller.title = "Från"
                controller.datePickerMode = completeDay ? .date : .dateAndTime
            }
        case .OpenToDatePicker:
            if let controller = segue.destination as? DatePickerViewController {
                dateSelect = .to
                controller.delegate = self
                controller.date = toDate
                controller.title = "Till"
                controller.datePickerMode = completeDay ? .date : .dateAndTime
            }
        }
    }
    
    func updateUI() {
        daySwitch?.isOn = completeDay

        if completeDay {
            fromLabel?.text = DateFormatter.short.string(from: fromDate)
            toLabel?.text = DateFormatter.short.string(from: toDate)
        } else {
            fromLabel?.text = DateFormatter.withTime.string(from: fromDate)
            toLabel?.text = DateFormatter.withTime.string(from: toDate)
        }
        
        switch reportType {
        case .absence:
            title = "Ledighet"
            break
        case .sickLeave:
            title = "Sjukfrånvaro"
            break
        }
    }
}

// MARK: Actions

extension ReportViewController {
    
    @IBAction func switchDidChange(_ mySwitch: UISwitch) {
        completeDay = mySwitch.isOn
    }
    
    @IBAction func didTapSendButton(_ objects: AnyObject?) {
        
        guard let  personalNumber = child?.personalNumber else {
            assertionFailure()
            return;
        }
        
        var message: String
        
        switch reportType {
        case .absence:
            message = MessageHelper.messageForAbsence(personalNumber: personalNumber, from: fromDate, to: toDate)
            break
        case .sickLeave:
            message = MessageHelper.messageForSickLeave(personalNumber: personalNumber, from: fromDate, to: toDate)
            break
        }
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = message
            controller.recipients = [MessageHelper.PhoneNumber]
            controller.messageComposeDelegate = self
            present(controller, animated: true, completion: nil)
        }
    }
}

extension ReportViewController: MFMessageComposeViewControllerDelegate {
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion:nil)
    }
}

// MARK: DatePickerDelegate

extension ReportViewController: DatePickerDelegate {
    
    func datePicker(_ controller: DatePickerViewController, didFinishWithDate date: Date?) {
        guard let date = date else {
            return
        }
        
        switch dateSelect {
        case .to:
            toDate = date
            break
        case .from:
            fromDate = date
            toDate = date
            break
        default:
            break
        }
        updateUI()
    }
}


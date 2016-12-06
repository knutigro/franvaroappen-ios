//
//  ReportViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-11.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import XLForm
import UIKit
import MessageUI

class ReportViewController: XLFormViewController {
    
    enum FormTag: String {
        case allDay = "all-day"
        case starts = "starts"
        case ends = "ends"
    }
    
    enum ReportType {
        case sickLeave
        case absence
    }
    
    var child: Child?
    var reportType = ReportType.sickLeave
    
    var completeDay = true
    var fromDate = Date()
    var toDate = Date()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.backgroundColor = UIColor.clear
        
        switch reportType {
        case .absence:
            title = NSLocalizedString("Ledighet", comment: "")
            break
        case .sickLeave:
            title = NSLocalizedString("Sjukfrånvaro", comment: "")
            break
        }
        
        let startDateDescriptor = form.formRow(withTag: FormTag.starts.rawValue)!
        let endDateDescriptor = form.formRow(withTag: FormTag.ends.rawValue)!
        startDateDescriptor.valueTransformer = DateValueTransformer.self
        endDateDescriptor.valueTransformer = DateValueTransformer.self
        startDateDescriptor.hidden = reportType == .sickLeave
        endDateDescriptor.hidden = reportType == .sickLeave
        updateFormRow(startDateDescriptor)
        updateFormRow(endDateDescriptor)
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(screen: "Report")
    }

    func initializeForm() {
        
        fromDate = Date()
        toDate = Date(timeInterval: 0, since: fromDate)

        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor()
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        
        // All-day
        row = XLFormRowDescriptor(tag: FormTag.allDay.rawValue, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: NSLocalizedString("Heldag", comment: ""))
        row.value = true;
        row.height = 56.0
        section.addFormRow(row)
        
        // Starts
        row = XLFormRowDescriptor(tag: FormTag.starts.rawValue, rowType: XLFormRowDescriptorTypeDateInline, title: NSLocalizedString("Från", comment: ""))
        row.height = 56.0
        row.value = fromDate
        section.addFormRow(row)
        
        // Ends
        row = XLFormRowDescriptor(tag: FormTag.ends.rawValue, rowType: XLFormRowDescriptorTypeDateInline, title: NSLocalizedString("Till", comment: ""))
        row.height = 56.0
        row.value = toDate
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        
        self.form = form
    }
    
    func updateValuesFromForm() {
        if let completeDay = form.formRow(withTag: FormTag.allDay.rawValue)?.value as? Bool {
            self.completeDay = completeDay
        }
        if let date = form.formRow(withTag: FormTag.starts.rawValue)?.value as? Date {
            fromDate = date
        }
        if let date = form.formRow(withTag: FormTag.ends.rawValue)?.value as? Date {
            toDate = date
        }
    }
}

// MARK: Actions

extension ReportViewController {
    
    @IBAction func didTapSendButton(_ objects: AnyObject?) {
        
        let validationErrors : Array<NSError> = formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
            showFormValidationError(validationErrors.first)
            return
        }
        
        guard let personalNumber = child?.personalNumber else {
            assertionFailure()
            return;
        }
        
        var message: String?
        
        switch reportType {
        case .absence:
            if (fromDate.compare(toDate) == .orderedDescending) {
                showAlert(message: NSLocalizedString("Till måste vara efter från", comment: ""))
            } else if (!completeDay && !NSCalendar.current.isDate(fromDate, inSameDayAs: toDate)) {
                showAlert(message: NSLocalizedString("Till och från måste vara samma dag om du inte anmäler heldagar", comment: ""))
            } else {
                message = MessageHelper.messageForAbsence(personalNumber: personalNumber, from: fromDate, to: toDate, completeDay: completeDay)
            }

            break
        case .sickLeave:
            if (!NSCalendar.current.isDateInToday(fromDate)) {
                showAlert(message: NSLocalizedString("Sjukfrånvaro måste anmälas samma dag", comment: ""))
            } else if (fromDate.compare(toDate) == .orderedDescending) {
                showAlert(message: NSLocalizedString("Till måste vara efter från", comment: ""))
            } else if (fromDate.compare(toDate) == .orderedSame) {
                message = MessageHelper.messageForSickLeave(personalNumber: personalNumber, from: fromDate, to: nil)
            } else {
                message = MessageHelper.messageForSickLeave(personalNumber: personalNumber, from: fromDate, to: toDate)
            }
            
            break
        }
        
        guard let body = message else {
            return
        }
        
        if (MFMessageComposeViewController.canSendText()) {
            Analytics.track(screen: "Sms")

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
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension ReportViewController: MFMessageComposeViewControllerDelegate {
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        var res = ""
        switch result {
        case .cancelled:
            res = Analytics.MessageComposeResult.cancelled.rawValue
            break
        case .failed:
            res = Analytics.MessageComposeResult.failed.rawValue
            break
        case .sent:
            res = Analytics.MessageComposeResult.sent.rawValue
            break
        }
        
        let category = reportType == ReportType.sickLeave ? "Sick Leave" : "Absence"
        
        Analytics.track(event: "Did send sms", attributes: [Analytics.kResultKey: res, Analytics.kSMSCategoryKey: category])

        self.dismiss(animated: true, completion:nil)
    }
}

// MARK: XLFormDescriptorDelegate

extension ReportViewController {
    
    override func formRowDescriptorValueHasChanged(_ formRow: XLFormRowDescriptor!, oldValue: Any!, newValue: Any!) {
        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)
        
        if formRow.tag == FormTag.allDay.rawValue {
            let startDateDescriptor = form.formRow(withTag: FormTag.starts.rawValue)!
            let endDateDescriptor = form.formRow(withTag: FormTag.ends.rawValue)!
            let dateStartCell: XLFormDateCell = startDateDescriptor.cell(forForm: self) as! XLFormDateCell
            let dateEndCell: XLFormDateCell = endDateDescriptor.cell(forForm: self) as! XLFormDateCell
            if (formRow.value! as AnyObject).valueData() as? Bool == true {
                startDateDescriptor.valueTransformer = DateValueTransformer.self
                endDateDescriptor.valueTransformer = DateValueTransformer.self
                dateStartCell.formDatePickerMode = .date
                dateEndCell.formDatePickerMode = .date
                endDateDescriptor.hidden = reportType == .sickLeave
                startDateDescriptor.hidden = reportType == .sickLeave
            } else {
                startDateDescriptor.valueTransformer = DateTimeValueTransformer.self
                endDateDescriptor.valueTransformer = DateTimeValueTransformer.self
                dateStartCell.formDatePickerMode = reportType == .sickLeave ? .time : .dateTime
                dateEndCell.formDatePickerMode = reportType == .sickLeave ? .time : .dateTime
                endDateDescriptor.hidden = false
                startDateDescriptor.hidden = false
            }
            updateFormRow(startDateDescriptor)
            updateFormRow(endDateDescriptor)
        } else if formRow.tag == FormTag.starts.rawValue {
            let startDateDescriptor = form.formRow(withTag: FormTag.starts.rawValue)!
            let endDateDescriptor = form.formRow(withTag: FormTag.ends.rawValue)!
            if (startDateDescriptor.value! as AnyObject).compare(endDateDescriptor.value as! Date) == .orderedDescending {
                // startDateDescriptor is later than endDateDescriptor
                endDateDescriptor.value = Date(timeInterval: 0, since: startDateDescriptor.value as! Date)
                endDateDescriptor.cellConfig.removeObject(forKey: "detailTextLabel.attributedText")
                updateFormRow(endDateDescriptor)
            }
        } else if formRow.tag == FormTag.ends.rawValue {
            let startDateDescriptor = form.formRow(withTag: FormTag.starts.rawValue)!
            let endDateDescriptor = form.formRow(withTag: FormTag.ends.rawValue)!
            let dateEndCell = endDateDescriptor.cell(forForm: self) as! XLFormDateCell
            if (startDateDescriptor.value! as AnyObject).compare(endDateDescriptor.value as! Date) == .orderedDescending {
                // startDateDescriptor is later than endDateDescriptor
                dateEndCell.update()
                let newDetailText =  dateEndCell.detailTextLabel!.text!
                let strikeThroughAttribute = [NSStrikethroughStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
                let strikeThroughText = NSAttributedString(string: newDetailText, attributes: strikeThroughAttribute)
                endDateDescriptor.cellConfig["detailTextLabel.attributedText"] = strikeThroughText
                updateFormRow(endDateDescriptor)
            } else {
                let endDateDescriptor = self.form.formRow(withTag: FormTag.ends.rawValue)!
                endDateDescriptor.cellConfig.removeObject(forKey: "detailTextLabel.attributedText")
                updateFormRow(endDateDescriptor)
            }
        }
        
        updateValuesFromForm()
    }
}

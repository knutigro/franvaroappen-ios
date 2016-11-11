//
//  ReportViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-11.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import StaticDataTableViewController
import UIKit

class ReportViewController: StaticDataTableViewController, SegueHandlerType {
    
    enum ReportType {
        case SickLeave
        case Absence
    }
    
    @IBOutlet weak var daySwitch: UISwitch?
    @IBOutlet weak var fromCell: UITableViewCell?
    @IBOutlet weak var toCell: UITableViewCell?
    @IBOutlet weak var fromLabel: UILabel?
    @IBOutlet weak var toLabel: UILabel?
    
    var child: Child?
    var reportType = ReportType.SickLeave
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
    
    func updateUI() {
        daySwitch?.isOn = completeDay

        if completeDay {
            fromLabel?.text = DateFormatter.short.string(from: fromDate)
            toLabel?.text = DateFormatter.short.string(from: toDate)
        } else {
            fromLabel?.text = DateFormatter.withTime.string(from: fromDate)
            toLabel?.text = DateFormatter.withTime.string(from: toDate)
        }
    }
}

// MARK: Actions

extension ReportViewController {
    
    @IBAction func switchDidChange(_ mySwitch: UISwitch) {
        completeDay = mySwitch.isOn
    }
}

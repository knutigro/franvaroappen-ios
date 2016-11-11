//
//  DatePickerViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-11.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit

protocol DatePickerDelegate {
    func datePicker(_ controller: DatePickerViewController, didFinishWithDate date: Date?)
}

class DatePickerViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker?
    @IBOutlet weak var cancelButton: UIBarButtonItem?
    
    var delegate: DatePickerDelegate?
    
    var datePickerMode = UIDatePickerMode.date

    var date: Date? {
        didSet {
            if let date = date {
                datePicker?.date = date
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = cancelButton
        if let date = date {
            datePicker?.date = date
        }
        
        datePicker?.datePickerMode = datePickerMode
        datePicker?.minimumDate = Date()
    }
    
    @IBAction func didTapDoneButton(_ sender: AnyObject?) {
        delegate?.datePicker(self, didFinishWithDate: self.datePicker?.date)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapCancelButton(_ sender: AnyObject?) {
        delegate?.datePicker(self, didFinishWithDate: nil)
        let _ = navigationController?.popViewController(animated: true)
    }
}

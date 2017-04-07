//
//  ViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-09.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit
import CoreData

class MenuViewController: UITableViewController, SegueHandlerType {

    @IBOutlet weak var reportSickLeaveCell: UITableViewCell?
    @IBOutlet weak var reportOtherAbsenceCell: UITableViewCell?
    @IBOutlet weak var reviewOnAppstoreCell: UITableViewCell?
    @IBOutlet weak var reviewOnAppstoreReminderBadge: UIView?
    @IBOutlet weak var sendInfoCell: UITableViewCell?
    @IBOutlet weak var childImageView: UIImageView?
    @IBOutlet weak var sickLeaveLabel: UILabel?
    @IBOutlet weak var absenceLabel: UILabel?
    @IBOutlet weak var infoLabel: UILabel?
    @IBOutlet weak var aboutSMSLabel: UILabel?
    @IBOutlet weak var aboutAppLabel: UILabel?

    let shareManager = ShareManager()

    var child: Child?
    
    var childEntity: NSManagedObject? {
        didSet {
            if let childEntity = childEntity {
                child = Child.newWith(managedObject: childEntity)
            }
        }
    }

    enum SegueIdentifier: String {
        case OpenReportSickLeave = "OpenReportSickLeave"
        case OpenReportOtherAbsence = "OpenReportOtherAbsence"
        case OpenSendInfo = "OpenSendInfo"
        case OpenChildList = "OpenChildList"
        case OpenEditChild = "OpenEditChild"
        case OpenInfo = "OpenInfo"
        case OpenAbout = "OpenAbout"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        sickLeaveLabel?.text = NSLocalizedString("Anmäl sjukfrånvaro", comment: "")
        absenceLabel?.text = NSLocalizedString("Anmäl ledighet", comment: "")
        infoLabel?.text = NSLocalizedString("Skicka information", comment: "")
        aboutSMSLabel?.text = NSLocalizedString("Om sms tjänsten", comment: "")
        aboutAppLabel?.text = NSLocalizedString("Om appen", comment: "")

        if let imageView = childImageView {
            imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        }
        childImageView?.layer.borderWidth = 1
        childImageView?.layer.borderColor = UIColor.white.cgColor
        
        assert(child != nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(screen: "Menu")
        
        if RatingManager.shouldRequestReview {
            RatingManager.requestReview()
            Analytics.track(event: Analytics.kRatingDialogEvent)
        }
    }
    
    func updateUI() {
        self.title = child?.name
        childImageView?.image = child?.image
        reviewOnAppstoreReminderBadge?.isHidden = RatingManager.didTapReviewLink
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue) {
        case .OpenEditChild:
            if let controller = segue.destination as? EditChildViewController {
                controller.childEntity = childEntity
                controller.delegate = self
            }
        case .OpenReportSickLeave:
            if let controller = segue.destination as? ReportViewController {
                controller.child = child
                controller.reportType = .sickLeave
            }
        case .OpenReportOtherAbsence:
            if let controller = segue.destination as? ReportViewController {
                controller.child = child
                controller.reportType = .absence
            }
        case .OpenSendInfo:
            if let controller = segue.destination as? SendInfoViewController {
                controller.child = child
            }
        default:
            break;
        }
    }
}

// MARK: Actions

extension MenuViewController {
    
    @IBAction func didTapEditButton(_ button: UIBarButtonItem) {
        
        let alert = UIAlertController(title: child?.name, message:nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ändra info", comment: ""), style: UIAlertActionStyle.default, handler:  { [weak self](action) in
            self?.performSegueWithIdentifier(.OpenEditChild, sender: self)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Byt barn", comment: ""), style: UIAlertActionStyle.default, handler:  { [weak self](action) in
            let _ = self?.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.barButtonItem = button
        }
        
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func didTapShareButton(_ barButton: UIBarButtonItem) {
        shareManager.openShareSelector(style: .actionSheet, viewController: self, barButton: barButton)
    }
}

// MARK: TableViewDelegate

extension MenuViewController: EditChildViewControllerDelegate {
    func editChildViewController(_ controller: EditChildViewController, didFinishWithChild child: NSManagedObject?) {
        self.childEntity = child
    }
}

// MARK: TableViewDelegate

extension MenuViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell == reportSickLeaveCell {
            if (child == nil) {
                showNoChildAlert()
            } else {
                performSegueWithIdentifier(.OpenReportSickLeave, sender: cell)
            }
        } else if cell == reportOtherAbsenceCell {
            if (child == nil) {
                showNoChildAlert()
            } else {
                performSegueWithIdentifier(.OpenReportOtherAbsence, sender: cell)
            }
        } else if cell == sendInfoCell {
            if (child == nil) {
                showNoChildAlert()
            } else {
                performSegueWithIdentifier(.OpenSendInfo, sender: cell)
            }
        } else if cell == reviewOnAppstoreCell {
            RatingManager.didTapReviewLink = true
            updateUI()
            UIApplication.shared.open(URL(string:"https://itunes.apple.com/se/app/anm%C3%A4l-fr%C3%A5nvaro-lidk%C3%B6ping/id1175852934?action=write-review")!, options: [String: Any](), completionHandler: nil)
            Analytics.track(event: Analytics.kDidTapReviewCellEvent)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func showNoChildAlert() {
        let alert = UIAlertController(title: nil,
                                      message: NSLocalizedString("Inget barn vald.", comment: ""),
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//
//  ViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-09.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    @IBOutlet weak var reportSickLeaveCell: UITableViewCell?
    @IBOutlet weak var reportOtherAbsenceCell: UITableViewCell?
    @IBOutlet weak var reviewOnAppstoreCell: UITableViewCell?
    @IBOutlet weak var aboutAppCell: UITableViewCell?
    @IBOutlet weak var infoCell: UITableViewCell?
    @IBOutlet weak var reviewOnAppstoreReminderBadge: UIView?
    @IBOutlet weak var sendInfoCell: UITableViewCell?
    @IBOutlet weak var childImageView: AvatarView?
    @IBOutlet weak var sickLeaveLabel: UILabel?
    @IBOutlet weak var absenceLabel: UILabel?
    @IBOutlet weak var infoLabel: UILabel?
    @IBOutlet weak var aboutSMSLabel: UILabel?
    @IBOutlet weak var aboutAppLabel: UILabel?

    let shareManager = ShareManager()

    var child: Child?
    var applicationRouter: ApplicationRouter?
    var childPersistenceController: ChildPersistenceProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if let childPersistenceController = childPersistenceController {
            applicationRouter = ApplicationRouter(viewController: self.navigationController ?? self, childPersistenceController: childPersistenceController)
        }

        sickLeaveLabel?.text = NSLocalizedString("Anmäl sjukfrånvaro", comment: "")
        absenceLabel?.text = NSLocalizedString("Anmäl ledighet", comment: "")
        infoLabel?.text = NSLocalizedString("Skicka information", comment: "")
        aboutSMSLabel?.text = NSLocalizedString("Om sms tjänsten", comment: "")
        aboutAppLabel?.text = NSLocalizedString("Om appen", comment: "")

        assert(child != nil, "child must have a value")
        assert(childPersistenceController != nil, "childPersistenceController must have a value")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(screen: .menu)
        
        if RatingManager.shouldRequestReview {
            RatingManager.requestReview()
            Analytics.track(event: .ratingDialog)
        }
    }
    
    func updateUI() {
        self.title = child?.name
        childImageView?.image = child?.image
        
        let hasImage = child?.image != nil ? NSNumber(value: 1) : NSNumber(value: 0)
        Analytics.trackValue(value: hasImage, forProfileAttribute: Analytics.ProfileAttributesKey.image)

        let didTapReviewLink = RatingManager.didTapReviewLink
        reviewOnAppstoreReminderBadge?.isHidden = didTapReviewLink
        UIApplication.shared.applicationIconBadgeNumber = didTapReviewLink ? 0 : 1
    }
}

// MARK: Actions

extension MenuViewController {
    
    @IBAction func didTapEditButton(_ button: UIBarButtonItem) {
        
        let alert = UIAlertController(title: child?.name, message:nil, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ändra info", comment: ""), style: UIAlertAction.Style.default, handler:  { [weak self](action) in
            guard let child = self?.child else { return }
            self?.applicationRouter?.presentEditChildViewController(with: child, delegate: self, animated: true)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Byt barn", comment: ""), style: UIAlertAction.Style.default, handler:  { [weak self](action) in
            let _ = self?.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        
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
    
    func editChildViewController(_ controller: EditChildViewController, didFinishWithChild child: Child?) {
        self.child = child
    }
    
}

// MARK: TableViewDelegate

extension MenuViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        guard let child = child else {
            showNoChildAlert()
            return
        }
        
        switch cell {
        case reportSickLeaveCell:
            applicationRouter?.presentReportViewController(with: child, type: .sickLeave, animated: true)
        case reportOtherAbsenceCell:
            applicationRouter?.presentReportViewController(with: child, type: .absence, animated: true)
        case sendInfoCell:
            applicationRouter?.presentSendInfoViewController(with: child, animated: true)
        case reviewOnAppstoreCell:
            RatingManager.didTapReviewLink = true
            updateUI()
            applicationRouter?.presenRatingViewController()
            Analytics.track(event: .didTapReviewCell)
        case aboutAppCell:
            applicationRouter?.presentAboutViewController(animated: true)
        case infoCell:
            applicationRouter?.presentInfoViewController(animated: true)
        default:
            print("Action is taken care of by Storyboard")
        }
    }
    
    public func showNoChildAlert() {
        let alert = UIAlertController(title: nil,
                                      message: NSLocalizedString("Inget barn vald.", comment: ""),
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

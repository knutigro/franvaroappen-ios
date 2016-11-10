//
//  ViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-09.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController, SegueHandlerType {

    @IBOutlet weak var reportSickLeaveCell: UITableViewCell?
    @IBOutlet weak var reportOtherAbsenceCell: UITableViewCell?
    @IBOutlet weak var sendInfoCell: UITableViewCell?
    @IBOutlet weak var childNameLabel: UILabel?
    @IBOutlet weak var childPersonalNumberLabel: UILabel?
    @IBOutlet weak var childImageView: UIImageView?

    var child: Child? {
        didSet {
            childNameLabel?.text = child?.name
            childPersonalNumberLabel?.text = child?.personalNumber
            childImageView?.image = child?.image
        }
    }

    enum SegueIdentifier: String {
        case OpenReportSickLeave = "OpenReportSickLeave"
        case OpenReportOtherAbsence = "OpenReportOtherAbsence"
        case OpenSendInfo = "OpenSendInfo"
        case OpenChildList = "OpenChildList"
        case EmbeddedChildrenGrid = "EmbeddedChildrenGrid"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        if let imageView = childImageView {
            imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        }
        childImageView?.layer.borderWidth = 1
        childImageView?.layer.borderColor = UIColor.white.cgColor
        
        child = Child(name: "Lind Grosland", personalNumber: "20131202-2313", image: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue) {
        case .OpenReportSickLeave:
            if let controller = segue.destination as? SendInfoViewController {
                controller.child = child
            }
        case .OpenReportOtherAbsence:
            if let controller = segue.destination as? SendInfoViewController {
                controller.child = child
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

// MARK: TableViewDelegate

extension MenuViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if (child == nil) {
            let alert = UIAlertController(title: nil,
                                          message: "Inget barn vald.",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        } else {
            if cell == reportSickLeaveCell {
                performSegueWithIdentifier(.OpenReportSickLeave, sender: cell)
            } else if cell == reportOtherAbsenceCell {
                performSegueWithIdentifier(.OpenReportOtherAbsence, sender: cell)
            } else if cell == sendInfoCell {
                performSegueWithIdentifier(.OpenSendInfo, sender: cell)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

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
    @IBOutlet weak var sendInfoCell: UITableViewCell?
    @IBOutlet weak var childImageView: UIImageView?

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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        if let imageView = childImageView {
            imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        }
        childImageView?.layer.borderWidth = 1
        childImageView?.layer.borderColor = UIColor.white.cgColor
        
        assert(child != nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = child?.name
        childImageView?.image = child?.image
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue) {
        case .OpenEditChild:
            if let controller = segue.destination as? EditChildViewController {
                controller.childEntity = childEntity
            }
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

// MARK: Actions

extension MenuViewController {
    
    @IBAction func didTapEditButton(_ button: UIButton) {
        
        let alert = UIAlertController(title: child?.name, message:nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Ändra info", style: UIAlertActionStyle.destructive, handler:  { [weak self](action) in
            self?.performSegueWithIdentifier(.OpenEditChild, sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Byt barn", style: UIAlertActionStyle.destructive, handler:  { [weak self](action) in
            let _ = self?.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: button.frame.midX, y: self.view.frame.height, width: 1.0, height: 1.0)
        }
        
        self.present(alert, animated: true, completion: nil)
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

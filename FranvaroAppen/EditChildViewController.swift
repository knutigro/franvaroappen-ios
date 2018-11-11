//
//  EditChildViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-09.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit

protocol EditChildViewControllerDelegate {
    func editChildViewController(_ controller: EditChildViewController, didFinishWithChild child: Child?);
}

class EditChildViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var personNumberLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var personalNumberTextField: UITextField!
    @IBOutlet weak var imageView: AvatarView?
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    var child: Child?
    var delegate: EditChildViewControllerDelegate?
    var applicationRouter: ApplicationRouter?
    var childPersistenceController: ChildPersistenceProtocol?

    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = self.cancelButton
        
        if let childPersistenceController = childPersistenceController {
            applicationRouter = ApplicationRouter(viewController: self.navigationController ?? self, childPersistenceController: childPersistenceController)
        }

        nameLabel.text = NSLocalizedString("Namn", comment: "")
        personNumberLabel.text = NSLocalizedString("Person nummer", comment: "")
        
        if let child = child {
            self.title = child.name
            nameTextField.text = child.name
            personalNumberTextField.text = child.personalNumber
            imageView?.image = child.image
        } else {
            self.title = NSLocalizedString("Lägg till barn", comment: "")
            nameTextField.text = ""
            personalNumberTextField.text = ""
        }
        
        assert(childPersistenceController != nil, "childPersistenceController must have a value")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.track(screen: .editChild)
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Fel", comment: ""),
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: Actions

extension EditChildViewController {
    
    @IBAction func didTapCancel(_ objects: AnyObject?) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func childFromData() -> (child: Child?, errorMessage: String?) {
        let name = nameTextField?.text ?? ""
        let personalNumber = personalNumberTextField?.text ?? ""
        guard !name.isEmpty else {
            return (child: nil, errorMessage: NSLocalizedString("Namn kan inte vara tomt", comment: ""))
        }
        guard !personalNumber.isEmpty else {
            return (child: nil, errorMessage: NSLocalizedString("Person nummer kan inte vara tomt", comment: ""))
        }
        guard personalNumber.isValidPersonalNumber else {
            return (child: nil, errorMessage: NSLocalizedString("Person nummer måste ha formen ÅÅMMDD-NNNN.", comment: ""))
        }
        return (child: Child(name: name, personalNumber: personalNumber, image: nil), errorMessage: nil)
    }
    
    @IBAction func didTapSave(_ objects: AnyObject?) {
        let data = childFromData()
        guard let child = data.child else {
            showAlert(message: data.errorMessage ?? "Fel")
            return
        }
        let image = imageView?.image
        
        childPersistenceController?.save(child: child, withChild: self.child, image: image, completion: { [weak self] (object, error) in
            
            if let object = object {
                self?.delegate?.editChildViewController(self!, didFinishWithChild: object)
                let _ = self?.navigationController?.popViewController(animated: true)
            } else {
                print("Could not save \(String(describing: error)), \(String(describing: error?.userInfo))")
            }
        })
    }
    
    @IBAction func didTapAvatar(_ sender: AnyObject?) {
        applicationRouter?.presentImagePickerController(from: self, sourceView: view, delegate: self, animated: true)
    }
}

// MARK: UIImagePickerControllerDelegate

extension EditChildViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        imageView?.image = image
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITextFieldDelegate

extension EditChildViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length + range.location > (textField.text?.count ?? 0) { return false  }
        
        if textField == nameTextField {
            if let text = nameTextField?.text {
                let newValue = (text as NSString).replacingCharacters(in: range, with: string)
                self.title = newValue
            }
            return true
        } else if textField == personalNumberTextField {
            if string == "" { return true }
            if (range.location <= 5) {
                return Int(string) != nil
            } else if (range.location == 6) {
                return string == "-"
            } else if (range.location <= 10) {
                return true
            } else {
                return false
            }
        }
        
        return true
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

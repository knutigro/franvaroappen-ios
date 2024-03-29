//
//  EditChildViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-09.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit
import CoreData

extension String {
    var isValidPersonalNumber: Bool {
        let pat = "\\d\\d\\d\\d\\d\\d-\\w\\w\\w\\w"
        let regex = try! NSRegularExpression(pattern: pat, options: [])
        return regex.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: self.count)) == 1
    }
}

protocol EditChildViewControllerDelegate {
    func editChildViewController(_ controller: EditChildViewController, didFinishWithChild child: NSManagedObject?);
}

class EditChildViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var personNumberLabel: UILabel!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var personalNumberTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    var childEntity: NSManagedObject?
    var delegate: EditChildViewControllerDelegate?

    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = self.cancelButton
        
        nameLabel.text = NSLocalizedString("Namn", comment: "")
        personNumberLabel.text = NSLocalizedString("Person nummer", comment: "")

        view.layoutIfNeeded()
        
        if let imageView = imageView {
            imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        }
        
        imageView?.layer.borderWidth = 1
        imageView?.layer.borderColor = UIColor.white.cgColor
        
        var child: Child?
        if let childEntity = childEntity {
            child = Child(managedObject: childEntity)
        }
        
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

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FAnalytics.track(screen: "Edit child")
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Fel", comment: ""),
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: Actions

extension EditChildViewController {
    
    @IBAction func didTapCancel(_ objects: AnyObject?) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func childFromData() -> Child? {
        let name = nameTextField?.text ?? ""
        let personalNumber = personalNumberTextField?.text ?? ""
        
        guard !name.isEmpty else {
            showAlert(message: NSLocalizedString("Namn kan inte vara tomt", comment: ""))
            return nil
        }
        
        guard !personalNumber.isEmpty else {
            showAlert(message: NSLocalizedString("Person nummer kan inte vara tomt", comment: ""))
            return nil
        }
        
        guard personalNumber.isValidPersonalNumber else {
            showAlert(message: NSLocalizedString("Person nummer måste ha formen ÅÅMMDD-NNNN.", comment: ""))
            return nil
        }
        
        return  Child(name: name, personalNumber: personalNumber, image: nil)
    }
    
    @IBAction func didTapSave(_ objects: AnyObject?) {
        
        guard let child = childFromData() else { return }
        let previousObject = childEntity
        let image = imageView?.image
        
        AppDelegate.originalAppDelegate?.dbManager.save(child: child, image: image, previousObject: previousObject, completion: { [weak self] (object, error) in
            
            if let object = object {
                self?.delegate?.editChildViewController(self!, didFinishWithChild: object)
                let _ = self?.navigationController?.popViewController(animated: true)
            } else {
                print("Could not save \(String(describing: error)), \(String(describing: error?.userInfo))")
            }
        })
    }
    
    @IBAction func didTapAvatar(_ sender: AnyObject?) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            imagePicker.modalPresentationStyle = .popover
        }
        present(imagePicker, animated: true, completion: nil)
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            let popper = imagePicker.popoverPresentationController
            popper?.sourceView = self.view
        }
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

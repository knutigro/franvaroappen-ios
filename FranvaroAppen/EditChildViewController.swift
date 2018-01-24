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
    func isPersonalNumber() -> Bool {
        let pat = "\\d\\d\\d\\d\\d\\d-\\d\\d\\d\\d"
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
            child = Child.newWith(managedObject: childEntity)
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
        Analytics.track(screen: "Edit child")
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Fel", comment: ""),
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: Actions

extension EditChildViewController {
    
    @IBAction func didTapCancel(_ objects: AnyObject?) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSave(_ objects: AnyObject?) {
        
        let name = nameTextField?.text ?? ""
        let personalNumber = personalNumberTextField?.text ?? ""
        
        guard !name.isEmpty else {
            showAlert(message: NSLocalizedString("Namn kan inte vara tomt", comment: ""))
            return
        }
        
        guard !personalNumber.isEmpty else {
            showAlert(message: NSLocalizedString("Person nummer kan inte vara tomt", comment: ""))
            return
        }
        
        guard personalNumber.isPersonalNumber() else {
            showAlert(message: NSLocalizedString("Person nummer måste ha formen ÅÅMMDD-NNNN.", comment: ""))
            return
        }

        save(child: Child(name: name, personalNumber: personalNumber, image: nil))
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

// MARK: CoreData

extension EditChildViewController {
    
    func save(child: Child) {
        
        guard let managedContext = AppDelegate.originalAppDelegate?.persistentContainer.viewContext else {
            return
        }
        
        if childEntity == nil {
            let entity = NSEntityDescription.entity(forEntityName: "ChildEntity", in: managedContext)!
            childEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        }
        
        guard let childEnity = childEntity else { return }

        childEnity.setValue(child.name, forKey: "name")
        childEnity.setValue(child.personalNumber, forKey: "personal_number")
        if let image = imageView?.image {
            childEnity.setValue(UIImageJPEGRepresentation(image, 1), forKey: "photo")
        }
        
        do {
            try managedContext.save()
            delegate?.editChildViewController(self, didFinishWithChild: childEnity)
            let _ = navigationController?.popViewController(animated: true)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}

// MARK: UIImagePickerControllerDelegate

extension EditChildViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
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
                return Int(string) != nil
            } else {
                return false
            }
        }
        
        return true
    }
}


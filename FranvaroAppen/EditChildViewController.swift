//
//  EditChildViewController.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-09.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit
import CoreData

class EditChildViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var personalNumberTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView?

    var childEntity: NSManagedObject?

    // MARK: View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Mitt barn"
        
        view.layoutIfNeeded()
        
        if let imageView = imageView {
            imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        }
        
        imageView?.layer.borderWidth = 1
        imageView?.layer.borderColor = UIColor.white.cgColor
        
        nameTextField.text = childEntity?.value(forKey: "name") as? String ?? ""
        personalNumberTextField.text = childEntity?.value(forKey: "personal_number") as? String ?? ""
        if let imageData = childEntity?.value(forKey: "photo") as? Data, let image = UIImage(data: imageData){
            imageView?.image = image
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Fel",
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: Actions

extension EditChildViewController {
    
    @IBAction func didTapSave(_ objects: AnyObject?) {
        
        let name = nameTextField?.text ?? ""
        let personalNumber = personalNumberTextField?.text ?? ""
        
        guard !name.isEmpty else {
            showAlert(message: "Namn kan inte vara tomt")
            return
        }
        
        guard !personalNumber.isEmpty else {
            showAlert(message: "Personnummer kan inte vara tomt")
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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
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

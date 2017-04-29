//
//  ViewController.swift
//  TinkoffChat
//
//  Created by user on 02.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var textColor: UILabel!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var aboutUser: UITextView!
    @IBOutlet weak var imageUser: UIButton!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    @IBOutlet weak var saveGCDButton: UIButton!
    
    let service: ProfileService = ProfileService()
    
    var user: User?
    var appUser: AppUser?
    
    func initViews(for user: User) {
        
    }

    // MARK: LifeCycleVC
    override func viewDidLoad() {
        super.viewDidLoad()
        //добавили жест при котором будет скрываться клавиатура (нажатие в свободное место)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapAction))
        self.view.addGestureRecognizer(tapGesture);
        
        
        
        self.userName.delegate = self
        self.aboutUser.delegate = self
        activityindicator.startAnimating()
        saveGCDButton.isEnabled = false
        
        appUser = service.getAppUser(complitionHandler: nil)
        
        
//        if let appUser = service.getAppUser(complitionHandler: nil) {
        if appUser != nil {
            user = appUser?.currentUser
            if let user = appUser!.currentUser {
                if let name = user.name {
                    self.userName.text = name
                }
                
                if let userDescription = user.userDescription {
                    self.aboutUser.text = userDescription
                }
                
                if let imageData = user.avatar {
                    self.imageUser.setImage(UIImage(data: imageData as Data), for: .normal)
                }
                activityindicator.stopAnimating()
                saveGCDButton.isEnabled = true
            }
        }
        
//        }
        
            
//            appUser = service.getAppUser {
//            self.user = self.appUser?.currentUser
//            self.initViews(for: self.user!)
//        }
//        
//        user = appUser?.currentUser
        
//        if let currentUser = 
//        let user = UserProfile()
//        user.get() { (name, aboutMe, imageData, textColor) in
//            self.userName.text = user.userName
//            self.aboutUser.text = user.descriptionUser
//            if user.userImage != nil {
//                self.imageUser.setImage(user.userImage, for: .normal)
//            }
//            let components = user.textColor.components(separatedBy: ",")
//            if user.textColor != "" {
//                let r = NSString(string: components[0]).floatValue
//                let g = NSString(string: components[1]).floatValue
//                let b = NSString(string: components[2]).floatValue
//                let a = NSString(string: components[3]).floatValue
//                self.textColor.textColor = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
//            }
//            self.activityindicator.stopAnimating()
//            self.saveGCDButton.isEnabled = true
//        }
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageUser.setImage(pickedImage, for: UIControlState.normal)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: Actions
    @IBAction func saveAction(_ sender: Any) {
        saveData()
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func colorAction(_ sender: UIButton) {
        self.textColor.textColor = sender.backgroundColor
    }
    
    @IBAction func imageAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil,
                                                message: "Добавить фото",
                                                preferredStyle: .actionSheet)
        let oneAction = UIAlertAction(title: "Галерея", style: .default) { _ in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        let twoAction = UIAlertAction(title: "Камера", style: .default) { _ in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        let threeAction = UIAlertAction(title: "Назад", style: .default) { _ in }
        
        alertController.addAction(oneAction)
        alertController.addAction(twoAction)
        alertController.addAction(threeAction)

        self.present(alertController, animated: true) { }
    }
    
    func onTapAction() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func saveData() {
//        let color = textColor.textColor!
//        let components = color.cgColor.components!
//        let colorAsString = String(format: "%f,%f,%f,%f", components[0], components[1], components[2], components[3])
        
//        let image = (imageUser.imageView?.image!)!
//        let user = UserProfile(name: userName.text!, descript: aboutUser.text, image: image, color: colorAsString)
        
        activityindicator.startAnimating()
        
        user?.userId = UIDevice.current.identifierForVendor?.uuidString
        user?.name = userName.text
        user?.userDescription = aboutUser.text
        
        if let avatarData = UIImagePNGRepresentation((imageUser.imageView?.image)!){
            self.user?.avatar = avatarData as NSData
        }
        
        service.saveProfile(user: user!) {
            DispatchQueue.main.async {
                self.activityindicator.stopAnimating()
                let alertController = UIAlertController(title: "Данные сохранены",                                                                                                        message: nil,
                                                        preferredStyle: .alert)
                let oneAction = UIAlertAction(title: "Ок", style: .default) { _ in }
                alertController.addAction(oneAction)
                self.present(alertController, animated: true) { }
            }
        }
//        print("Сохранение данных профиля")
//        
//        saveGCDButton.isEnabled = false
//        
//        user.save(completed: {
//            self.activityindicator.stopAnimating()
//            self.saveGCDButton.isEnabled = true
//            
//            let alertController = UIAlertController(title: "Данные сохранены",
//                                                    message: nil,
//                                                    preferredStyle: .alert)
//            let oneAction = UIAlertAction(title: "Ок", style: .default) { _ in }
//            alertController.addAction(oneAction)
//            self.present(alertController, animated: true) { }
//        }) {
//            self.activityindicator.stopAnimating()
//            let alertController = UIAlertController(title: "Ошибка",
//                                                    message: "Не удалось сохранить",
//                                                    preferredStyle: .alert)
//            let oneAction = UIAlertAction(title: "Ок", style: .cancel) { _ in }
//            let twoAction = UIAlertAction(title: "Повторить", style: .default) { _ in
//                self.saveData()
//            }
//            alertController.addAction(oneAction)
//            alertController.addAction(twoAction)
//            self.present(alertController, animated: true) { }
//        }
    }
}


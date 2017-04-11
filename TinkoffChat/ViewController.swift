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
    
    var chel: Chalenge!
    
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    
    @IBOutlet weak var saveGCDButton: UIButton!
    @IBOutlet weak var saveOperationButton: UIButton!
    
    private var tapCounter = 0
    //между вьюдидлоад и вьювилэпир высчитываются кострейны ВАЖНЫЙ ВОПРОС) 
    //вьюдид эпир - срабатывает когда вью появлявилась на экране
    //вью вилдезапир - срабатывает перед тем как экран уходит
    //вьюдидДезапир - когда экран ушел
    //viewDidUnload - 
    //большой круг срабатывает, когда мы ушли с экрана 
    //Память работает через референс каунт, а не через гербежколлектор; ARC - automaticRefenceCount
    //retainCycle - прочитать, два объекта ссылаются друг на друга и висят в памяти, хотя на них нет ссылок

    // MARK: LifeCycleVC
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(#function)")
        self.controlsSayDescription()
        
        //добавили жест при котором будет скрываться клавиатура (нажатие в свободное место)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapAction))
        self.view.addGestureRecognizer(tapGesture);
        
        self.userName.delegate = self
        self.aboutUser.delegate = self
        activityindicator.startAnimating()
        saveGCDButton.isEnabled = false
        saveOperationButton.isEnabled = false
        GCDDataManager.getFile { (name, aboutMe, imageData, textColor) in
            self.userName.text = name
            self.aboutUser.text = aboutMe
            let components = textColor.components(separatedBy: ",")
            if textColor != "" {
                self.imageUser.setImage(UIImage(data: imageData), for: .normal)
                let r = NSString(string: components[0]).floatValue
                let g = NSString(string: components[1]).floatValue
                let b = NSString(string: components[2]).floatValue
                let a = NSString(string: components[3]).floatValue
                self.textColor.textColor = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
            }
            self.activityindicator.stopAnimating()
            self.saveGCDButton.isEnabled = true
            self.saveOperationButton.isEnabled = true
            self.activityindicator.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(#function)")
        self.controlsSayDescription()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(#function)")
        self.controlsSayDescription()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(#function)")
        self.controlsSayDescription()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(#function)")
        self.controlsSayDescription()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(#function)")
        self.controlsSayDescription()
        
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

    @IBAction func operationSaveAction(_ sender: Any) {
        let color = textColor.textColor!
        let components = color.cgColor.components!
        let colorAsString = String(format: "%f,%f,%f,%f", components[0], components[1], components[2], components[3])
        let operation = OperationDataManager(userName: userName.text,
                                             aboutMe: aboutUser.text,
                                             image: UIImagePNGRepresentation((imageUser.imageView?.image)!),
                                             colorText: colorAsString)
        operation.completionBlock = {
            self.activityindicator.stopAnimating()
            self.saveGCDButton.isEnabled = true
            self.saveOperationButton.isEnabled = true
            
            let alertController = UIAlertController(title: "Данные сохранены",
                                                    message: nil,
                                                    preferredStyle: .alert)
            let oneAction = UIAlertAction(title: "Ок", style: .default) { _ in }
            alertController.addAction(oneAction)
            self.present(alertController, animated: true) { }
        }
        let queue = OperationQueue()
        queue.addOperation(operation)
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
        //юзера сделать через модельку и в сохранение передавать ее
//        let user = UserProfile(name: userName.text!, descript: aboutUser.text, image: (imageUser.imageView?.image!)!)
        activityindicator.startAnimating()
        print("Сохранение данных профиля")
        
        saveGCDButton.isEnabled = false
        saveOperationButton.isEnabled = false
        
        let color = textColor.textColor!
        let components = color.cgColor.components!
        let colorAsString = String(format: "%f,%f,%f,%f", components[0], components[1], components[2], components[3])
        GCDDataManager.saveFile(name: userName.text!,
                                aboutMe: aboutUser.text,
                                image: UIImagePNGRepresentation((imageUser.imageView?.image)!)!,
                                colorText: colorAsString,
                                completed: {
                                    self.activityindicator.stopAnimating()
                                    self.saveGCDButton.isEnabled = true
                                    self.saveOperationButton.isEnabled = true
                                    
                                    let alertController = UIAlertController(title: "Данные сохранены",
                                                                            message: nil,
                                                                            preferredStyle: .alert)
                                    let oneAction = UIAlertAction(title: "Ок", style: .default) { _ in }
                                    alertController.addAction(oneAction)
                                    self.present(alertController, animated: true) { }
        }) {
            self.activityindicator.stopAnimating()
            let alertController = UIAlertController(title: "Ошибка",
                                                    message: "Не удалось сохранить",
                                                    preferredStyle: .alert)
            let oneAction = UIAlertAction(title: "Ок", style: .cancel) { _ in }
            let twoAction = UIAlertAction(title: "Повторить", style: .default) { _ in
                self.saveData()
            }
            alertController.addAction(oneAction)
            alertController.addAction(twoAction)
            self.present(alertController, animated: true) { }
        }
    }
    
    func controlsSayDescription() {
//        for view in view.subviews {
//            print("\(view.classForCoder) frame: \(view.frame)")
//        }
//        print("\n")
    }
}

//Таблицы 
// таблица стиля плей - хедер и футер не уезжают / плейн - скролятся, как обычные строки
// table.view.rowHeight = UITableViewAutomaticDimension - считает автоматически, table.view.estimatedRowHeight = 44 - для автоматического расчета высоты ячеек приблизительное значение
// метод таблевью естимейтХайтФоРоуАт - говорит какой высоты должна быть ячеек


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
        print("Сохранение данных профиля")
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
    
    func controlsSayDescription() {
        for view in view.subviews {
            print("\(view.classForCoder) frame: \(view.frame)")
        }
        print("\n\n")
    }
}

//Таблицы 
// таблица стиля плей - хедер и футер не уезжают / плейн - скролятся, как обычные строки
// table.view.rowHeight = UITableViewAutomaticDimension - считает автоматически, table.view.estimatedRowHeight = 44 - для автоматического расчета высоты ячеек приблизительное значение
// метод таблевью естимейтХайтФоРоуАт - говорит какой высоты должна быть ячеек


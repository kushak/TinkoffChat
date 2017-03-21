//
//  ViewController.swift
//  TinkoffChat
//
//  Created by user on 02.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var textColor: UILabel!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var aboutUser: UITextView!
    
    private var tapCounter = 0
    //между вьюдидлоад и вьювилэпир высчитываются кострейны ВАЖНЫЙ ВОПРОС) 
    //вьюдид эпир - срабатывает когда вью появлявилась на экране
    //вью вилдезапир - срабатывает перед тем как экран уходит
    //вьюдидДезапир - когда экран ушел
    //viewDidUnload - 
    //большой круг срабатывает, когда мы ушли с экрана 
    //Память работает через референс каунт, а не через гербежколлектор; ARC - automaticRefenceCount
    //retainCycle - прочитать, два объекта ссылаются друг на друга и висят в памяти, хотя на них нет ссылок
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controlsSayDescription()
        print("\(#function)\n\n\n")
        
        //добавили жест при котором будет скрываться клавиатура (нажатие в свободное место)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapAction))
        self.view.addGestureRecognizer(tapGesture);
        
        self.userName.delegate = self
        self.aboutUser.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.controlsSayDescription()
        print("\(#function)\n\n\n")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.controlsSayDescription()
        print("\(#function)\n\n\n")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.controlsSayDescription()
        print("\(#function)\n\n\n")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.controlsSayDescription()
        print("\(#function)\n\n\n")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.controlsSayDescription()
        print("\(#function)\n\n\n")
    }
    
    func onTapAction() {
        view.endEditing(true)
    }
    
    func controlsSayDescription() {
        print(self.textColor.description)
        print(self.userName.description)
        print(self.aboutUser.description)
    }

    @IBAction func saveAction(_ sender: Any) {
        print("Сохранение данных профиля");
    }

    @IBAction func colorAction(_ sender: UIButton) {
        self.textColor.backgroundColor = sender.backgroundColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
//    func textView
}


//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by user on 27.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var conversation: Conversation?
//    var userName: String?
    var messages = [Message]()

    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintForKeyboard: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = conversation?.name
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapAction))
        self.view.addGestureRecognizer(tapGesture);
        
        loadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.tableView.scrollToRow(at: NSIndexPath.init(row: self.messages.count - 1, section: 0) as IndexPath, at: .bottom, animated: true)
        registerForKeyboardNotifications()
        registerForComunicatorManager()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerForComunicatorManager() {
        NotificationCenter.default.addObserver(self, selector: #selector(foundUser(_:)), name: NSNotification.Name(rawValue: "didFoundUser"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(lostUser(_:)), name: NSNotification.Name(rawValue: "didLostUser"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveMessage(_:)), name: NSNotification.Name(rawValue: "didReceiveMessage"), object: nil)
    }
    
    func foundUser(_ notification: NSNotification) {
        if !(conversation?.online)! {
            let userID = notification.userInfo?["user"] as! String
            if userID == conversation?.userID {
                sendButton.isEnabled = true
                conversation?.online = true
            }
        }
    }
    
    func lostUser(_ notification: NSNotification) {
        if (conversation?.online)! {
            let userID = notification.userInfo?["user"] as! String
            if userID == conversation?.userID {
                sendButton.isEnabled = false
                conversation?.online = false
            }
        }
    }
    
    func receiveMessage(_ notification: NSNotification){
        let text = notification.userInfo?["text"] as! String
        let forConversation = notification.userInfo?["user"] as! String
        if forConversation == conversation?.name {
            addMessage(text: text, isInputMessage: true)
        }
    }
    
    func addMessage(text: String, isInputMessage: Bool) {
        DispatchQueue.main.async {
            let message = Message(text: text, isInputMessage: isInputMessage)
            message.date = Date.init(timeIntervalSinceNow: 0)
            self.messages.append(message)
            
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .top)
            
            self.tableView.scrollToRow(at: NSIndexPath.init(row: self.messages.count - 1, section: 0) as IndexPath, at: .bottom, animated: true)
            
            self.tableView.reloadData()
        }
    }
    
    func loadMessages() {
        messages = (conversation?.messages)!
        tableView.reloadData()
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        if messageField.text != "" {
            view.endEditing(true)
            addMessage(text: messageField.text!, isInputMessage: false)
            CommunicationManager.sharedInstance.sendMessage(text: messageField.text!, toUser: (conversation?.userID)!)
            messageField.text = ""
        }
    }
    
    func onTapAction() {
        view.endEditing(true)
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = messages[indexPath.row].isInputMessage! ?
            tableView.dequeueReusableCell(withIdentifier: "InputMessage", for: indexPath) as! ConversationCell :
            tableView.dequeueReusableCell(withIdentifier: "OutputMessage", for: indexPath) as! ConversationCell
        
        cell.fillWithModel(model: messages[indexPath.row])
        
        return cell
    }
    
    
    //MARK: - Keyboard
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardSize = keyboardFrame.cgRectValue.size
        
        let duration = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval
        let curve = userInfo.value(forKey: UIKeyboardAnimationCurveUserInfoKey) as! UInt
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.constraintForKeyboard.constant = keyboardSize.height
        }, completion: nil)
        
        if self.messages.count != 0 {
            tableView.scrollToRow(at: NSIndexPath.init(row: self.messages.count - 1, section: 0) as IndexPath, at: .top, animated: true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let duration = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval
        let curve = userInfo.value(forKey: UIKeyboardAnimationCurveUserInfoKey) as! UInt
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.constraintForKeyboard.constant = 0
        }, completion: nil)
    }
}

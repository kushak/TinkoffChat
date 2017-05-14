//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by user on 27.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var conversation: Conversation1?
//    var messages = [Message]()
    var conversationService: ConversationService?

    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintForKeyboard: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        conversationService = ConversationService(tableView: tableView, conversation: conversation!)
        navigationItem.title = conversation?.user?.name
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapAction))
        self.view.addGestureRecognizer(tapGesture);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToBottom()
        registerForKeyboardNotifications()
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        if messageField.text != "" {
            if let message = messageField.text {
                conversationService?.sendMessage(text: message)
            }
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
        guard let frc = conversationService?.fetchedResultsController, let sectionsCount =
            frc.sections?.count else {
                return 0
        }
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let frc = conversationService?.fetchedResultsController, let sections = frc.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier: String
        if let message = conversationService?.fetchedResultsController?.object(at: indexPath) {
            if message.sender == conversation?.user {
                identifier = "OutputMessage"
            } else {
                identifier = "InputMessage"
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ConversationCell{
                if let message = conversationService?.fetchedResultsController?.object(at: indexPath) {
                    cell.fillWithModel(model: message)
                }
                return cell
            }
        }
        
        return ConversationCell()
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
        
        scrollToBottom()
    }
    
    func keyboardWillHide(notification: NSNotification){
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let duration = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval
        let curve = userInfo.value(forKey: UIKeyboardAnimationCurveUserInfoKey) as! UInt
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.constraintForKeyboard.constant = 0
        }, completion: nil)
    }
    
    func scrollToBottom() {
        if let lastMessage = conversationService?.fetchedResultsController?.fetchedObjects?.last {
            if let lastIndexPatch = conversationService?.fetchedResultsController?.indexPath(forObject: lastMessage) {
                tableView.scrollToRow(at: lastIndexPatch, at: .bottom, animated: true)
            }
        }

    }
}

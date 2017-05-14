
//  ConversationListCell.swift
//  TinkoffChat
//
//  Created by user on 26.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class ConversationListCell: UITableViewCell, ConversationCellConfiguration {

    var name: String?
    var message: String?
    var date: Date?
    var online: Bool?
    var hasUnreadMessage: Bool?
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var messageDate: UILabel!
    
    func fillWithModel(model: Conversation1) {
//        name = model.name
//        message = model.messages.last?.text
//        date = model.date
//        online = model.online
//        hasUnreadMessage = model.hasUnreadMessage
        name = model.user?.name
        message = model.lastMessage?.text
        date = model.lastMessage?.date as Date?
        online = model.user?.isOnline
        hasUnreadMessage = model.isRead
        
        initControls()
    }
    
    func initControls() {
        avatar.layoutIfNeeded()
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = avatar.frame.size.height / 2
        avatar.image = UIImage.init(named: "User")
        if name != nil {
            userName.text = name
        } else {
            userName.text = "NoName :D"
        }
        
        if message != nil {
            if hasUnreadMessage != nil {
                if hasUnreadMessage! {
                    messageText.font = UIFont.boldSystemFont(ofSize: 14)
                }
            }
            messageText.text = message
            if date != nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                messageDate.text = dateFormatter.string(from: date!)
            }
            
            if online != nil {
                if online! {
                    self.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 210/255, alpha: 1)
                } else {
                    self.backgroundColor = UIColor.white
                }
            }
            
        } else {
            messageText.text = "No messages yet"
        }
    }
    
    override func prepareForReuse() {
        avatar.image = nil
        userName.text = ""
        messageText.text = ""
        messageDate.text = ""
        self.backgroundColor = UIColor.clear
    }
}

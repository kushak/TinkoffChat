//
//  ConvesationCell.swift
//  TinkoffChat
//
//  Created by user on 27.03.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, MessageCellConfiguration {
    
    var textMessage: String?
    var isInputMessage: Bool?
    
    @IBOutlet weak var viewForText: UIView!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    func fillWithModel(model: Message) {
        textMessage = model.text
        isInputMessage = model.isInputMessage
        
        initControls()
    }
    
    func initControls() {
        messageTextLabel.preferredMaxLayoutWidth = self.contentView.frame.size.width * 2/3
        messageTextLabel.text = textMessage
        
//        print("messageTextLabel.center = \(messageTextLabel.center)")
//        messageTextLabel.layoutIfNeeded()
//        print("messageTextLabel.center = \(messageTextLabel.center)")
        
//        if isInputMessage! {
//            viewForText.frame.size.width = messageTextLabel.frame.size.width + 16
//            viewForText.frame.size.height = messageTextLabel.frame.size.height + 16
//        viewForText.center = messageTextLabel.center
//        } else {
//            let width = messageTextLabel.frame.size.width + 16
//            let height = messageTextLabel.frame.size.height + 16
//            let x = messageTextLabel.frame.origin.x - 8
//            let y = messageTextLabel.frame.origin.y - 8
//            viewForText.frame = CGRect.init(x: x, y: y, width: width, height: height)
//            print("messageTextLabel = \(messageTextLabel.frame.origin)")
//            print("viewForText.origin = \(viewForText.frame.origin)")
//            viewForText.frame.size.width = messageTextLabel.frame.size.width + 16
//            viewForText.frame.size.height = messageTextLabel.frame.size.height + 16
//        }
//        
//        viewForText.layoutIfNeeded()
//        viewForText.layer.masksToBounds = false
//        viewForText.layer.cornerRadius = 8
    }
    //        viewForText.translatesAutoresizingMaskIntoConstraints = false
    //        messageTextLabel.translatesAutoresizingMaskIntoConstraints = false
    //
    //        let views = ["viewForText":viewForText]
    //        let horizontalConstraint1 =
    //            NSLayoutConstraint.constraints(withVisualFormat: "|-[viewForText]",
    //                                           options: NSLayoutFormatOptions(rawValue: 0),
    //                                           metrics: nil,
    //                                           views: views)
    //        let verticalConstraint1 =
    //            NSLayoutConstraint.constraints(withVisualFormat: "V:|-[viewForText]",
    //                                           options: NSLayoutFormatOptions(rawValue: 0),
    //                                           metrics: nil,
    //                                           views: views)
    //        self.addConstraints(horizontalConstraint1)
    //        self.addConstraints(verticalConstraint1)
}

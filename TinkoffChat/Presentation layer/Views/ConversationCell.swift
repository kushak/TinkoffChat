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
    
    @IBOutlet weak var messageTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    func fillWithModel(model: Message1) {
        textMessage = model.text
//        isInputMessage = model.isInputMessage
        initControls()
    }
    
    func initControls() {
        messageTextLabel.preferredMaxLayoutWidth = self.contentView.frame.size.width * 2/3
        messageTextLabel.text = textMessage
    }
}

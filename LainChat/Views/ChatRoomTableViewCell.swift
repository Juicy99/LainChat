//
//  ChatRoomTableViewCell.swift
//  LainChat
//
//  Created by Juicy99 on 2021/02/21.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
    
    var messegeText: String?{
        didSet{
            guard  let text = messegeText else {return}
            let witdh = estimateFrameForTextView(text: text).width + 20
            
            messegeTextViewWidthConstraint.constant = witdh
            messageTextView.text = text
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messegeTextViewWidthConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        userImageView.layer.cornerRadius = 30
        
        messageTextView.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func estimateFrameForTextView(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
}

//
//  ChatRoomTableViewCell.swift
//  LainChat
//
//  Created by Juicy99 on 2021/02/21.
//

import UIKit
import Firebase

class ChatRoomTableViewCell: UITableViewCell {
    
    var message: Message?{
        didSet{
//            guard  let text = messegeText else {return}
//
//            messageTextView.text = text
            if let message = message{
                partnerMessageTextView.text = message.message
                let witdh = estimateFrameForTextView(text: message.message).width + 20
                messegeTextViewWidthConstraint.constant = witdh
                partnerDateLabel.text = dateFormatterForDateLabel(date: message.createdAt.dateValue())
//                userImageView.image =
            }
        }
    }
    
    @IBOutlet weak var partnerMessageTextView: UITextView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var myMessageTextView: UITextView!
    @IBOutlet weak var partnerDateLabel: UILabel!
    @IBOutlet weak var messegeTextViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var myDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        userImageView.layer.cornerRadius = 30
        
        partnerMessageTextView.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func checkWhichUserMessage() {
          guard let uid = Auth.auth().currentUser?.uid else { return }
          
          if uid == message?.uid {
              partnerMessageTextView.isHidden = true
              partnerDateLabel.isHidden = true
              userImageView.isHidden = true
              
              myMessageTextView.isHidden = false
              myDateLabel.isHidden = false
          } else {
              partnerMessageTextView.isHidden = false
              partnerDateLabel.isHidden = false
              userImageView.isHidden = false
              
              myMessageTextView.isHidden = true
              myDateLabel.isHidden = true
          }
          
      }
    
    private func estimateFrameForTextView(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
    private func dateFormatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
}

//
//  ChatRoomTableViewCell.swift
//  LainChat
//
//  Created by Juicy99 on 2021/02/21.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseUI
import Nuke

class ChatRoomTableViewCell: UITableViewCell {
    
    var message: Message? {
        didSet {
//            if let message = message {
//                partnerMessageTextView.text = message.message
//                let witdh = estimateFrameForTextView(text: message.message).width + 20
//                messageTextViewWidthConstraint.constant = witdh
//
//                partnerDateLabel.text = dateFormatterForDateLabel(date: message.createdAt.dateValue())
//
//
//            }
        }
    }
    
    @IBOutlet weak var partnerName: UILabel!
    @IBOutlet weak var partnerMessageTextView: UITextView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var myMessageTextView: UITextView!
    @IBOutlet weak var partnerDateLabel: UILabel!
    @IBOutlet weak var myDateLabel: UILabel!
    @IBOutlet weak var messageTextViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var myMessageTextViewWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        userImageView.layer.cornerRadius = 30
        partnerMessageTextView.layer.cornerRadius = 15
        myMessageTextView.layer.cornerRadius = 15
    }
    let imageSample = UIImageView()

    
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkWhichUserMessage()
    }
    
    private func checkWhichUserMessage() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if uid == message?.uid {
            partnerMessageTextView.isHidden = true
            partnerDateLabel.isHidden = true
            userImageView.isHidden = true
            partnerName.isHidden = true
            
            myMessageTextView.isHidden = false
            myDateLabel.isHidden = false
            
            if let message = message {
                myMessageTextView.text = message.message
                let witdh = estimateFrameForTextView(text: message.message).width + 20
                myMessageTextViewWidthConstraint.constant = witdh
                
                myDateLabel.text = dateFormatterForDateLabel(date: message.createdAt.dateValue())
            }
        } else {
            partnerMessageTextView.isHidden = false
            partnerDateLabel.isHidden = false
            userImageView.isHidden = false
            partnerName.isHidden = false
            myMessageTextView.isHidden = true
            myDateLabel.isHidden = true
            }
        
        if let urlString = message?.profileImageUrl, let url = URL(string: urlString) {
                        Nuke.loadImage(with: url, into: userImageView)
                    }
        
            if let message = message {
                partnerName.text = message.name
                partnerMessageTextView.text = message.message
                let witdh = estimateFrameForTextView(text: message.message).width + 20
                messageTextViewWidthConstraint.constant = witdh
                partnerDateLabel.text = dateFormatterForDateLabel(date: message.createdAt.dateValue())
        }
        
    }
    
    private func addBackground(name: String) {
        
        imageSample.image = UIImage(named: name)
         
        // 画像を読み込んで、準備しておいたimageSampleに設定
        imageSample.image = UIImage(named: name)
         
        // 設定した画像をスクリーンに表示する
        self.userImageView.addSubview(imageSample)

        }
    
    private func estimateFrameForTextView(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    private func dateFormatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
}

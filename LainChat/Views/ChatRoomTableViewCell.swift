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
    
    @IBAction func partnerDropDownTapped(_ sender: UIButton) {
        partnerAddMenuToButton()
    }
    @IBAction func myDropDownTapped(_ sender: UIButton) {
        myAddMenuToButton()
    }
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var partnerButton: UIButton!
    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var partnerName: UILabel!
    @IBOutlet weak var partnerMessageTextView: UITextView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var myMessageTextView: UITextView!
    @IBOutlet weak var partnerDateLabel: UILabel!
    @IBOutlet weak var myDateLabel: UILabel!
    @IBOutlet weak var messageTextViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var myMessageTextViewWidthConstraint: NSLayoutConstraint!
    
    func myAddMenuToButton(){
        let copy = UIAction(title: "コピー", image: UIImage(systemName: "doc.on.doc")) { (action) in
            print("コピー")
        }
        let add = UIAction(title: "編集", image: UIImage(systemName: "pencil")) { (action) in
            print("編集")
        }
        let trash = UIAction(title: "削除", image: UIImage(systemName: "trash")?.withTintColor(.red,renderingMode: .alwaysOriginal)) { (action) in
            print("削除")
        }
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [copy, add, trash])
        myButton.menu = menu
        myButton.showsMenuAsPrimaryAction = true
    }
    
    func partnerAddMenuToButton(){
        let translate = UIAction(title: "翻訳", image: UIImage(systemName: "character.ja")) { (action) in
            print("翻訳")
        }
        let copy = UIAction(title: "コピー", image: UIImage(systemName: "doc.on.doc")) { (action) in
            print("コピー")
        }
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [translate, copy])
        partnerButton.menu = menu
        partnerButton.showsMenuAsPrimaryAction = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        userImageView.layer.cornerRadius = 30
        myImageView.layer.cornerRadius = 30
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
            partnerButton.isHidden = true
            
            myImageView.isHidden = false
            myName.isHidden = false
            myMessageTextView.isHidden = false
            myDateLabel.isHidden = false
            myButton.isHidden = false
            
            if let message = message {
                myName.text = message.name
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
            partnerButton.isHidden = false
            
            myImageView.isHidden = true
            myName.isHidden = true
            myMessageTextView.isHidden = true
            myDateLabel.isHidden = true
            myButton.isHidden = true
            }
        
        
        if let urlString = message?.profileImageUrl, let url = URL(string: urlString) {
            Nuke.loadImage(with: url, into: userImageView) ;Nuke.loadImage(with: url, into: myImageView)
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

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
    @IBAction func myDropDownTapped(_ sender: UIButton) {
        myAddMenuToButton()
    }
    @IBAction func otherAction(_ sender: Any) {
        otherAddMenuToButton()
    }
    
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var otherName: UILabel!
    @IBOutlet weak var otherMessageTextView: UITextView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var myMessageTextView: UITextView!
    @IBOutlet weak var otherDateLabel: UILabel!
    @IBOutlet weak var myDateLabel: UILabel!
    @IBOutlet weak var messageTextViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var myMessageTextViewWidthConstraint: NSLayoutConstraint!

    
    func myAddMenuToButton(){
        
        let trash = UIAction(title: "削除", image: UIImage(systemName: "trash")?.withTintColor(.red,renderingMode: .alwaysOriginal)) { (action) in
            Firestore.firestore().collection("chatRooms").document("lobby").collection("messages").document(self.message!.messageId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    self.alert(title: "サーバーから削除しました", message: "")
                    print("削除")
                }
            }
        }
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [trash])
        myButton.menu = menu
        myButton.showsMenuAsPrimaryAction = true
    }
    
    func otherAddMenuToButton(){
        
        let trash = UIAction(title: "削除", image: UIImage(systemName: "trash")?.withTintColor(.red,renderingMode: .alwaysOriginal)) { (action) in
            Firestore.firestore().collection("chatRooms").document("lobby").collection("messages").document(self.message!.messageId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    self.alert(title: "サーバーから削除しました", message: "")
                    print("削除")
                }
            }
        }
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [trash])
        otherButton.menu = menu
        otherButton.showsMenuAsPrimaryAction = true
    }
    

    
    func alert(title: String, message: String)  {
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.parentViewController()?.present(alert, animated: true, completion: nil)
        alert.dismiss(animated: false, completion: nil)
     }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        userImageView.layer.cornerRadius = 30
        myImageView.layer.cornerRadius = 30
        otherMessageTextView.layer.cornerRadius = 15
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
            otherMessageTextView.isHidden = true
            otherDateLabel.isHidden = true
            userImageView.isHidden = true
            otherName.isHidden = true
            otherButton.isHidden = true
            
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
            otherMessageTextView.isHidden = false
            otherDateLabel.isHidden = false
            userImageView.isHidden = false
            otherName.isHidden = false
            otherButton.isHidden = false
            
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
                otherName.text = message.name
                otherMessageTextView.text = message.message
                let witdh = estimateFrameForTextView(text: message.message).width + 20
                messageTextViewWidthConstraint.constant = witdh
                otherDateLabel.text = dateFormatterForDateLabel(date: message.createdAt.dateValue())
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
extension UIView {
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            parentResponder = nextResponder
        }
    }

    func parentView<T: UIView>(type: T.Type) -> T? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let view = nextResponder as? T {
                return view
            }
            parentResponder = nextResponder
        }
    }
}

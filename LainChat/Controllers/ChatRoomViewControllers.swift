//
//  ChatRoomViewControllers.swift
//  LainChat
//
//  Created by Juicy99 on 2021/02/20.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController {
    
    var user: User?
    var chatroom: ChatRoom?
    
    private let cellId = "cellId"
    private var messages = [Message]()
    
    private lazy var chatInputAccessoryView: ChatInputAccessoryView = {
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        view.delegate = self
        return view
        
    }()
    
    @IBOutlet weak var ChatRoomTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChatRoomTableView.backgroundColor = .white
        
        ChatRoomTableView.delegate = self
        ChatRoomTableView.dataSource = self
        ChatRoomTableView.register(UINib(nibName: "ChatRoomTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        ChatRoomTableView.backgroundColor = .black
        fetchMessages()
    }
    
    override var inputAccessoryView: UIView?{
        get {
            return chatInputAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    private func fetchMessages() {
        Firestore.firestore().collection("chatRooms").document("lobby").collection("messages").addSnapshotListener( { (snapshots, err) in
            if let err = err {
                print("メッセージ情報の取得に失敗しました。\(err)")
                return
            }
            
            snapshots?.documentChanges.forEach({(DocumentChange) in
                switch DocumentChange.type{
                case.added:
                    let dic = DocumentChange.document.data()
                    let message = Message(dic: dic)
                    message.partnerUser = self.chatroom?.partnerUser
                    
                    self.messages.append(message)
                    self.ChatRoomTableView.reloadData()
                    print("messge dic: ", dic)
                    
                case . modified, .removed:
                    print("nothing to do ")
                }
            })
        })
    }
    
}

extension ChatRoomViewController:ChatInputAccessoryViewDelegate{
    
    
    func tappedSendButton(text: String) {
        
        guard let name = user?.username else {return}
        guard let uid = Auth.auth().currentUser?.uid else { return}
        chatInputAccessoryView.removetext()
        
        
        let docData = [
            "name": name,
            "createdAt": Timestamp(),
            "uid": uid,
            "message": text
        ] as [String : Any]
        
        Firestore.firestore().collection("chatRooms").document("lobby").collection("messages").document().setData(docData) { (err) in
            if let err = err {
                print("メッセージ情報の保存に失敗しました。\(err)")
                return
            }
            print("メッセージの保存に成功しました。")
            
        }
    }
}

extension ChatRoomViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ChatRoomTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatRoomTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as!
        ChatRoomTableViewCell
//        cell.messageTextView.text = messgaes[indexPath.row]
        cell.message = messages[indexPath.row]
    return cell
    }
}

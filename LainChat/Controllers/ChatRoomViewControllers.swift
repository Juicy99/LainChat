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
    
    private let cellId = "cellId"
    private var messgaes = [String]()
    
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
    }
    
    override var inputAccessoryView: UIView?{
        get {
            return chatInputAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
}

extension ChatRoomViewController:ChatInputAccessoryViewDelegate{
    
    
    func tappedSendButton(text: String) {
//
//        messgaes.append(text)
//        chatInputAccessoryView.removetext()
//        ChatRoomTableView.reloadData()
        
        guard let name = user?.username else {return}
        guard let uid = Auth.auth().currentUser?.uid else { return}
        
        
        let docData = [
            "name": name,
            "createdAt": Timestamp(),
            "uid": uid,
            "messega": text
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
        return messgaes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatRoomTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as!
        ChatRoomTableViewCell
//        cell.messageTextView.text = messgaes[indexPath.row]
        cell.messegeText = messgaes[indexPath.row]
    return cell
    }
}

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
    private var messages = [Message]()
    private let accessoryHeight: CGFloat = 100
    private let tableViewContentinset: UIEdgeInsets = .init(top: 70, left: 0, bottom: 0, right: 0)
    private let tableViewIndicatorInset: UIEdgeInsets = .init(top: 70, left: 0, bottom: 0, right: 0)
    private var safeAreaBottom: CGFloat{
        self.view.safeAreaInsets.bottom
    }
    
    private lazy var chatInputAccessoryView: ChatInputAccessoryView = {
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        view.delegate = self
        return view
        
    }()
    
    
    @IBOutlet weak var chatRoomTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "ChatImage.jpg")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.chatRoomTableView.frame.width, height: self.chatRoomTableView.frame.height))
        imageView.image = image
        self.chatRoomTableView.backgroundView = imageView
        
        setupNotification()
        setupChatRoomTableView()
        fetchMessages()
    }
    
    private func setupNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupChatRoomTableView(){
        
        chatRoomTableView.backgroundColor = .white
        
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        chatRoomTableView.register(UINib(nibName: "ChatRoomTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        chatRoomTableView.backgroundColor = .black
        chatRoomTableView.contentInset = tableViewContentinset
        chatRoomTableView.scrollIndicatorInsets = tableViewIndicatorInset
        chatRoomTableView.keyboardDismissMode = .interactive
        chatRoomTableView.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        print("keboa")
       guard let userInfo = notification.userInfo else { return }
        
        if let keyboradFrame = (userInfo[ UIResponder.keyboardFrameEndUserInfoKey ] as AnyObject).cgRectValue{
            
            if keyboradFrame.height <= accessoryHeight { return }
            
            let top = keyboradFrame.height - safeAreaBottom
            var moveY = -(top - chatRoomTableView.contentOffset.y)
            if chatRoomTableView.contentOffset.y != -70 { moveY += 70 }
            let contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        
            chatRoomTableView.contentInset = contentInset
            chatRoomTableView.scrollIndicatorInsets = contentInset
            chatRoomTableView.contentOffset = CGPoint(x: 0, y: moveY)
            
        }
        
    }
    
    @objc func keyboardWillHide(){
        print("keboasss")
        chatRoomTableView.contentInset = tableViewIndicatorInset
        chatRoomTableView.scrollIndicatorInsets = tableViewIndicatorInset
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
                    self.messages.append(message)
                    self.messages.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date > m2Date
                    }
                    self.chatRoomTableView.reloadData()
//                    self.chatRoomTableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
                    
                case . modified, .removed:
                    print("nothing to do ")
                }
            })
        })
    }
    
}



extension ChatRoomViewController:ChatInputAccessoryViewDelegate{
    
    
    func tappedSendButton(text: String) {
        addMessageToFirestore(text: text)

    }
    
    private func addMessageToFirestore(text: String){
        guard let name = user?.username else {return}
        guard let image = user?.profileImageUrl else {return}
        guard let uid = Auth.auth().currentUser?.uid else { return}
        chatInputAccessoryView.removetext()
        
        
        let docData = [
            "name": name,
            "createdAt": Timestamp(),
            "uid": uid,
            "message": text,
            "proFileImageUrl": image
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
        chatRoomTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatRoomTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as!
        ChatRoomTableViewCell
//        cell.messageTextView.text = messgaes[indexPath.row]
        cell.message = messages[indexPath.row]
        cell.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
    return cell
    }
}

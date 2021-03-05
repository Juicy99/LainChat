//
//  TopViewController.swift
//  LainChat
//
//  Created by Juicy99 on 2021/03/02.
//

import UIKit
import Firebase
import Nuke

class TopViewController: UIViewController {
    private var user: User?
    private var chatroom: ChatRoom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .black
        
        navigationItem.title = "トーク"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        if Auth.auth().currentUser?.uid == nil {
            let storyboar = UIStoryboard(name: "SignUp", bundle: nil)
            let   SignUpViewController = storyboar.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            SignUpViewController.modalPresentationStyle = .fullScreen
            self.present(SignUpViewController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLoginUserInfo()
    }
    
    private func fetchChatroomsInfoFromFirestore() {
            Firestore.firestore().collection("chatRooms").getDocuments { (snapshots, err) in
                if let err = err {
                    print("ChatRooms情報の取得に失敗しました。\(err)")
                    return
                }
                
                snapshots?.documents.forEach({ (snapshot) in
                    let dic = snapshot.data()
                    let chatroom = ChatRoom(dic: dic)
                    
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    chatroom.members.forEach { (memberUid) in
                        if memberUid != uid {
                            Firestore.firestore().collection("users").document(memberUid).getDocument { (snaoshot, err) in
                                if let err = err {
                                    print("ユーザー情報の取得に失敗しました。\(err)")
                                    return
                                }
                                                            
                                guard let dic = snaoshot?.data() else { return }
                                let user = User(dic: dic)
                                user.uid = snapshot.documentID
                                
                                chatroom.partnerUser = user
                                self.chatroom = chatroom
                            }
                            
                        }
                    }
                })
                
            }
            
        }
private func fetchLoginUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("ユーザー情報の取得に失敗しました。\(err)")
                return
            }
            
            guard let snapshot = snapshot, let dic = snapshot.data() else { return }
            
            let user = User(dic: dic)
            self.user = user
        }
    }
    
    @IBAction func chatButton(_ sender: UIButton) {
        fetchChatroomsInfoFromFirestore()
        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let chatRoomViewController = storyboard.instantiateViewController(identifier: "ChatRoomViewController") as! ChatRoomViewController
        
        let washingtonRef = Firestore.firestore().collection("chatRooms").document("lobby")
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // Atomically add a new region to the "regions" array field.
        washingtonRef.updateData([
            "members": FieldValue.arrayUnion([uid])
        ]){ [self] (err) in
            if let err = err {
                print("ChatRoom情報の保存に失敗しました。\(err)")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            print("ChatRoom情報の保存に成功しました。")
            chatRoomViewController.user = user
            chatRoomViewController.chatroom = chatroom
            navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
    }
    
}

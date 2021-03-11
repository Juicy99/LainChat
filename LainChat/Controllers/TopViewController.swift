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
    
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .black
        
        navigationItem.title = "ようこそワイヤードへ"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        
        if Auth.auth().currentUser?.uid == nil {
            let storyboar = UIStoryboard(name: "SignUp", bundle: nil)
            let   SignUpViewController = storyboar.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            SignUpViewController.modalPresentationStyle = .fullScreen
            self.present(SignUpViewController, animated: true, completion: nil)
        }
        
        
        
        let image1 = UIImage(named:"laintop0")!
               let image2 = UIImage(named:"laintop1")!
               let image3 = UIImage(named:"laintop2")!
        let image4 = UIImage(named:"laintop3")!
        let image5 = UIImage(named:"laintop4")!
        let image6 = UIImage(named:"laintop5")!
         
               
               // UIImage の配列を作る
               var imageListArray :Array<UIImage> = []
               // UIImage 各要素を追加、ちょっと冗長的ですが...
               imageListArray.append(image1)
               imageListArray.append(image2)
               imageListArray.append(image3)
               imageListArray.append(image4)
        imageListArray.append(image5)
        imageListArray.append(image6)
        
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height

        // スクリーンサイズにあわせてimageViewの配置
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        
               // view に追加する
        
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
               
               // 画像Arrayをアニメーションにセット
               imageView.animationImages = imageListArray
               
               // 間隔（秒単位）
        imageView.animationDuration = 0.6
               // 繰り返し
               imageView.animationRepeatCount = 0
               
               // アニメーションを開始
               imageView.startAnimating()
        
        
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
            navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
    }
    
}

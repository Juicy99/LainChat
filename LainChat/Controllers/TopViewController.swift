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
    
 
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .black
        
        navigationItem.title = "ようこそワイヤードへ"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        
        if Auth.auth().currentUser?.uid == nil {
            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
            let   SignUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            SignUpViewController.modalPresentationStyle = .fullScreen
            self.present(SignUpViewController, animated: true, completion: nil)
            
        }
        self.playButton.frame = CGRect(x: (self.view.frame.size.width / 2) - 150, y: (self.view.frame.size.height / 2) - 50, width: 300, height: 100)
         
            let picture = UIImage(named: "Play")
             
            self.playButton.setImage(picture, for: .normal)
            self.view.addSubview(playButton)
        
        self.settingButton.frame = CGRect(x: (self.view.frame.size.width / 2) - 150, y: (self.view.frame.size.height / 2) - 50, width: 300, height: 100)
         
            let picture2 = UIImage(named: "Setting")
             
            self.settingButton.setImage(picture2, for: .normal)
            self.view.addSubview(settingButton)
        
        
        
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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLoginUserInfo()
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
    
    
    @IBAction func setting(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let   settingViewController = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    
    @IBAction func chatButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let chatRoomViewController = storyboard.instantiateViewController(identifier: "ChatRoomViewController") as! ChatRoomViewController
        navigationController?.pushViewController(chatRoomViewController, animated: true)
        addLoginMessageToFirestore()
    }
    
    private func addLoginMessageToFirestore(){
        guard let name = user?.username else {return}
        let image = "https://firebasestorage.googleapis.com/v0/b/lain-that.appspot.com/o/profile_image%2Fmosaic.png?alt=media&token=718ec2f9-0c36-41c9-8ca9-cb240c78f8af"
        guard let uid = Auth.auth().currentUser?.uid else { return}
        let messageId = randomString(length: 20)
        
        
        let docData = [
            "name": name,
            "createdAt": Timestamp(),
            "message": name + "さんがアクセスしました。",
            "profileImageUrl": image,
            "uid": uid + "さんがアクセスしました。",
            "messageId": messageId
        ] as [String : Any]
        
        Firestore.firestore().collection("chatRooms").document("lobby").collection("messages").document().setData(docData) { (err) in
            if let err = err {
                print("メッセージ情報の保存に失敗しました。\(err)")
                return
            }
            print("メッセージの保存に成功しました。")
            
        }
    }
    
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
}

class RippleButton: UIButton {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        drawRipple(touch: touches.first!)
    }
    private func drawRipple(touch: UITouch) {
        let rippleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        rippleView.layer.cornerRadius = 100
        rippleView.center = touch.location(in: self)
        rippleView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        rippleView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        addSubview(rippleView)
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: UIView.AnimationOptions.curveEaseIn,
            animations: {
                rippleView.transform = CGAffineTransform(scaleX: 1, y: 1)
                rippleView.backgroundColor = .clear
            },
            completion: { (finished: Bool) in
                rippleView.removeFromSuperview()
            }
        )
    }
}

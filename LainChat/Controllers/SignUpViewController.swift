//
//  SignUpViewController.swift
//  LainChat
//
//  Created by Juicy99 on 2021/02/22.
//

import UIKit
import Firebase
import GradientCircularProgress

class SignUpViewController: UIViewController{
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    let progress = GradientCircularProgress()
    @IBAction func tappedProfileImageButton(_ sender: Any) {
let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackground(name: "SignUpImage")
        
        profileImageButton.layer.cornerRadius = 85
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.black.cgColor
        
        registerButton.layer.cornerRadius = 10
        
        registerButton.addTarget(self, action: #selector(tappedRegisterButton), for:  .touchUpInside)
        
        userNameTextField.delegate = self
        
        registerButton.isEnabled = false
        registerButton.backgroundColor = .systemGray5
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.configureObserver()

    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        self.removeObserver() // Notificationを画面が消えるときに削除
    }

    // Notificationを設定
    func configureObserver() {

        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // Notificationを削除
    func removeObserver() {

        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }

    // キーボードが現れた時に、画面全体をずらす。
    @objc func keyboardWillShow(notification: Notification?) {

        let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
            self.view.transform = transform

        })
    }

    // キーボードが消えたときに、画面を戻す
    @objc func keyboardWillHide(notification: Notification?) {

        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in

            self.view.transform = CGAffineTransform.identity
        })
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 入力を反映させたテキストを取得する
        let resultText: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if resultText.count <= 10 {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder() // Returnキーを押したときにキーボードを下げる
        return true
    }
    
    func addBackground(name: String) {
            // スクリーンサイズの取得
            let width = UIScreen.main.bounds.size.width
            let height = UIScreen.main.bounds.size.height

            // スクリーンサイズにあわせてimageViewの配置
            let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            //imageViewに背景画像を表示
            imageViewBackground.image = UIImage(named: name)

            // 画像の表示モードを変更。
            imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill

            // subviewをメインビューに追加
        self.backgroundImage.addSubview(imageViewBackground)
            // 加えたsubviewを、最背面に設置する
        self.backgroundImage.sendSubviewToBack(imageViewBackground)
        }
    
    @objc private func tappedRegisterButton() {
        let alert: UIAlertController = UIAlertController(title: "サービスを利用するには利用規約に同意が必要です。", message:  "利用規約を確認してください", preferredStyle:  UIAlertController.Style.alert)
        // 確定ボタンの処理
        let confirmAction: UIAlertAction = UIAlertAction(title: "利用規約に同意", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            guard let image = self.profileImageButton.imageView?.image else {return}
           guard let uploadImage = image.jpegData(compressionQuality: 0.01) else {return}
            
            self.progress.show(message: "頑張ってます・・",style: MyStyle())
            
            let fileName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
            
            storageRef.putData(uploadImage, metadata: nil) { (matadata, err) in
                if let err = err {
                    print("Firestorageへの情報の保存に失敗しました。\(err)")
                    self.dismiss(animated: true, completion: nil)
                 self.navigationController?.popViewController(animated: true)
                    return
                }
                
                storageRef.downloadURL { (url, err) in
                    if let err = err {
                        print("Firestorageからのダウンロードに失敗しました。\(err)")
                        self.dismiss(animated: true, completion: nil)
                     self.navigationController?.popViewController(animated: true)
                        return
                    }
                    
                    guard let urlString = url?.absoluteString else { return }
                    self.createUserToFirestore(profileImageUrl: urlString)
                }
                
            }
        })
        // キャンセルボタンの処理
        let cancelAction: UIAlertAction = UIAlertAction(title: "利用規約をみる", style: UIAlertAction.Style.cancel, handler:{
            // キャンセルボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            let url = URL(string: "https://juicy997.hatenablog.com/entry/2021/04/27/004621")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        })

        //UIAlertControllerにキャンセルボタンと確定ボタンをActionを追加
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)

        //実際にAlertを表示する
        present(alert, animated: true, completion: nil)
        
    }

       private func createUserToFirestore(profileImageUrl: String) {
       Auth.auth().signInAnonymously() { (authResult, err) in
           if let err = err {
               print("認証情報の保存に失敗しました。\(err)")
               return
           }

           guard let user = authResult?.user else { return } // true
           let uid = user.uid
           guard let username = self.userNameTextField.text else { return }
           let docData = [
               "username": username,
               "createdAt": Timestamp(),
               "profileImageUrl": profileImageUrl
               ] as [String : Any]
           Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
               if let err = err {
                   print("Firestoreへの保存に失敗しました。\(err)")
                   return
               }
               
               print("Firestoreへの情報の保存が成功しました。")
               self.dismiss(animated: true, completion: nil)
               
           }
                  return
              }
           
       }
       

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

    extension SignUpViewController: UITextFieldDelegate {
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            let usernameIsEmpty = userNameTextField.text?.isEmpty ?? false
            
            if usernameIsEmpty{
                registerButton.isEnabled = false
                registerButton.backgroundColor = .gray
            } else{
                registerButton.isEnabled = true
                registerButton.backgroundColor = .systemGray5
            }
        }
        
    }

extension SignUpViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage{
            profileImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        profileImageButton.setTitle("", for:  .normal)
        profileImageButton.imageView?.contentMode = .scaleToFill
        profileImageButton.contentHorizontalAlignment = .fill
        profileImageButton.contentVerticalAlignment = .fill
        profileImageButton.clipsToBounds = true
        dismiss(animated: true, completion: nil)
 
}

    }

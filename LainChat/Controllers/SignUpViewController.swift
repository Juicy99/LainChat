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
        let image = profileImageButton.imageView?.image ?? UIImage(named: "vince_carter")
        guard let uploadImage = image?.jpegData(compressionQuality: 0.3) else { return }
        
        progress.show(message: "頑張ってます・・",style: MyStyle())
        
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
        
        storageRef.putData(uploadImage, metadata: nil) { [self] (matadata, err) in
            if let err = err {
                print("Firestorageへの情報の保存に失敗しました。\(err)")
                self.progress.show(message: "頑張ってます・・",style: MyStyle())
                return
            }
            
            storageRef.downloadURL { (url, err) in
                if let err = err {
                    print("Firestorageからのダウンロードに失敗しました。\(err)")
                    progress.show(message: "頑張ってます・・",style: MyStyle())
                    return
                }
                
                guard let urlString = url?.absoluteString else { return }
                self.createUserToFirestore(proFileImageUrl: urlString)
            }
            
        }
        
    }

    private func createUserToFirestore(proFileImageUrl: String) {
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
            "proFileImageUrl": proFileImageUrl
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
            print(" : ", textField.text)
            let usernameIsEmpty = userNameTextField.text?.isEmpty ?? false
            
            if usernameIsEmpty{
                registerButton.isEnabled = false
                registerButton.backgroundColor = .systemGray5
            } else{
                registerButton.isEnabled = true
                registerButton.backgroundColor = .gray
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

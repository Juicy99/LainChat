//
//  SignUpViewController.swift
//  LainChat
//
//  Created by Juicy99 on 2021/02/22.
//

import UIKit
import Firebase
import GradientCircularProgress

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    let progress = GradientCircularProgress()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.layer.cornerRadius = 10
        
        registerButton.addTarget(self, action: #selector(tappedRegisterButton), for:  .touchUpInside)
        
        userNameTextField.delegate = self
        
        registerButton.isEnabled = false
        registerButton.backgroundColor = .gray
        
        
    }
    
    @objc private func tappedRegisterButton() {
        
        
        progress.show(message: "頑張ってます・・",style: MyStyle())
                self.createUserToFirestore()
        return
    }

    private func createUserToFirestore() {
        let progress = GradientCircularProgress()
    Auth.auth().signInAnonymously() { (authResult, err) in
        if let err = err {
            print("認証情報の保存に失敗しました。\(err)")
            progress.dismiss()
            return
        }

        guard let user = authResult?.user else { return } // true
        let uid = user.uid
        guard let username = self.userNameTextField.text else { return }
        let docData = [
            "username": username,
            "createdAt": Timestamp(),
            ] as [String : Any]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            if let err = err {
                print("Firestoreへの保存に失敗しました。\(err)")
                progress.dismiss()
                return
            }
            
            print("Firestoreへの情報の保存が成功しました。")
            progress.dismiss()
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
            registerButton.backgroundColor = .gray
        } else{
            registerButton.isEnabled = true
            registerButton.backgroundColor = .systemGray5
        }
    }
}

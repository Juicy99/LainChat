//
//  ChatRoomViewControllers.swift
//  LainChat
//
//  Created by Juicy99 on 2021/02/20.
//

import UIKit
class ChatRoomViewController: UIViewController {
    
    private let cellId = "cellId"
    
    @IBOutlet weak var ChatRoomTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChatRoomTableView.backgroundColor = .white
        
        ChatRoomTableView.delegate = self
        ChatRoomTableView.dataSource = self
        ChatRoomTableView.register(UINib(nibName: "ChatRoomTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        ChatRoomTableView.backgroundColor = .black
    }
}
extension ChatRoomViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ChatRoomTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatRoomTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    return cell
    }
}

//
//  ChatListViewController.swift
//  LainChat
//
//  Created by Juicy99 on 2021/02/18.
//

import UIKit

class ChatListViewController: UIViewController {
    
    private let cellId = "cellId"
    
    @IBOutlet weak var chatListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
        
        
        
        }
}

extension ChatListViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
    return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(#function)
            let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
            let chatRoomViewController = storyboard.instantiateViewController(identifier: "ChatRoomViewController")
            navigationController?.pushViewController(chatRoomViewController, animated: true)
    }}

class ChatListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var latestMssageLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 35
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

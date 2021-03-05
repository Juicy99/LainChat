//
//  ChatRoom.swift
//  LainChat
//
//  Created by Juicy99 on 2021/03/04.
//

import Foundation
import Firebase

class ChatRoom {
    
    let members: [String]
    
    var documentId: String?
    var partnerUser: User?
    
    init(dic: [String: Any]) {
        self.members = dic["members"] as? [String] ?? [String]()
    }
    
}

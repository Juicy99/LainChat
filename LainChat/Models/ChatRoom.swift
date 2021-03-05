//
//  ChatRoom.swift
//  LainChat
//
//  Created by Juicy99 on 2021/03/04.
//

import Foundation
import Firebase

class ChatRoom {
    
    let latestMessageId: String
    let memebers: [String]
    let createdAt: Timestamp
    
    var documentId: String?
    var partnerUser: User?
    
    init(dic: [String: Any]) {
        self.latestMessageId = dic["latestMessageId"] as? String ?? ""
        self.memebers = dic["memebers"] as? [String] ?? [String]()
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
    
}

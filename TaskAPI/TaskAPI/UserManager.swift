//
//  UserManager.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-06.
//

import Foundation

class UserManager {
    static var userId: Int?
    static var username: String?
    
    static var userInfo: UserInfo? {
        guard let userId = userId, let username = username else { return nil }
        return UserInfo(id: userId, username: username)
    }
}

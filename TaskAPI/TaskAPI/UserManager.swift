//
//  UserManager.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-06.
//

import Foundation

class UserManager {
    static var userId: Int? {
        didSet {
            print(userId)
        }
    }
    static var username: String? {
        didSet {
            print(username)
        }
    }
}

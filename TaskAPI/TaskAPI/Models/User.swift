//
//  User.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-01.
//

import Foundation

struct UserAuthenticationRequest: Encodable {
    let username: String?
    let password: String?
}

struct UserAuthenticationResponse: Decodable {
    let userId: Int
}

struct UserInfo: Codable {
    let id: Int
    let username: String?
}

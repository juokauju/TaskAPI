//
//  Task.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-01.
//

import Foundation

struct TaskRequest: Encodable {
    let title: String
    let description: String
    let estimateMinutes: Int
    let assigneeId: Int
}

struct TaskResponse: Decodable {
    var id: Int?
    let title: String?
    let description: String?
    let estimateMinutes: Int
    var loggedTime: Int
    var isDone: Bool
    let assigneeInfo: UserInfo
}

struct UpdateTaskRequest: Encodable {
    let title: String?
    let description: String?
    let estimateMinutes: Int
    let assigneeId: Int
    var loggedTime: Int
    var isDone: Bool
}

struct TasksResponse: Decodable {
    let tasks: [TaskResponse?]
}

struct RegisterTaskResponse: Codable {
    let taskId: Int
}

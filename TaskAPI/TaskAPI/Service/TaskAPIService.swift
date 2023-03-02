//
//  TaskAPIService.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-01.
//

import UIKit

struct TaskAPIResource {
    private let baseURLString = "http://134.122.94.77"
    
    enum Endpoint: String {
        case loginUser = "/api/user/login"
        case registerUser = "/api/user/register"
        case deleteUser = "/api/user/" // + userId
        case allUserTasks = "/api/task/userTasks?userId=" // +userId
        case task = "api/Task/" // + taskId for specific task
    }
    
    func buildUrl(for endpoint: Endpoint, id: Int? = nil) -> URL? {
        var urlString = baseURLString + endpoint.rawValue
        if let id = id {
            urlString += String(id)
        }
        return URL(string: urlString)
    }
}

enum NetworkError: Error {
    case url
    case response
    case service
}

class TaskAPIService {
    let resource = TaskAPIResource()
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    enum HttpMethod: String {
        case GET, POST, PUT, DELETE
    }
    
    private func buildRequest(_ url: URL, method: HttpMethod, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        if method == .POST {
            request.httpMethod = method.rawValue
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        request.httpMethod = method.rawValue
        return request
    }
    
    private func load(_ url: URL, method: HttpMethod, body: Data? = nil) async throws -> Data {
        let request = buildRequest(url, method: method, body: body)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkError.response }
        return data
    }
    
    func register(user: UserAuthenticationRequest, completion: @escaping (UserAuthenticationResponse?) -> Void) {
        guard let url = resource.buildUrl(for: .registerUser) else {
            print(NetworkError.url)
            completion(nil)
            return
        }
        Task {
            do {
                let data = try encoder.encode(user)
                let responseData = try await load(url, method: .POST, body: data)
                let response = try decoder.decode(UserAuthenticationResponse.self, from: responseData)
                completion(response)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func login(user: UserAuthenticationRequest, completion: @escaping (UserAuthenticationResponse?) -> Void) {
        guard let url = resource.buildUrl(for: .loginUser) else {
            print(NetworkError.url)
            completion(nil)
            return
        }
        Task {
            do {
                let data = try encoder.encode(user)
                let responseData = try await load(url, method: .POST, body: data)
                let response = try decoder.decode(UserAuthenticationResponse.self, from: responseData)
                completion(response)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func getAllTasks(completion: @escaping ([TaskResponse]) -> Void) {
        guard let url = resource.buildUrl(for: .task) else {
            print(NetworkError.url)
            completion([])
            return
        }
        Task {
            do {
                let data = try await load(url, method: .GET)
                let result = try decoder.decode([TaskResponse].self, from: data)
                completion(result)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func getTasksForUser(id: Int, completion: @escaping ([TaskResponse?]) -> Void) {
        guard let url = resource.buildUrl(for: .allUserTasks, id: id) else {
            print(NetworkError.url)
            completion([])
            return
        }
        Task {
            do {
                print(url)
                let data = try await load(url, method: .GET)
                let result = try decoder.decode(TasksResponse.self, from: data)
                completion(result.tasks)
            } catch {
                print("Error: \(error)")
            }
        }
    }

}
    

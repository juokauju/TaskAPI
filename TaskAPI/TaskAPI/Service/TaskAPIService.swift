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
        case task = "api/Task/" // + taskId for delete and get specific task
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
    case badUrl
    case httpRequestError
    case networkFailure
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
    
    @discardableResult
    private func load(_ url: URL, method: HttpMethod, body: Data? = nil) async throws -> Data {
        let request = buildRequest(url, method: method, body: body)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkError.httpRequestError }
        return data
    }
    
    func register(user: UserAuthenticationRequest,
                  completion: @escaping (Result<UserAuthenticationResponse, NetworkError>) -> Void) {
        
        guard let url = resource.buildUrl(for: .registerUser) else {
            completion(.failure(NetworkError.badUrl))
            return
        }
        
        Task {
            do {
                let data = try encoder.encode(user)
                let responseData = try await load(url, method: .POST, body: data)
                let response = try decoder.decode(UserAuthenticationResponse.self, from: responseData)
                completion(.success(response))
            } catch {
                completion(.failure(NetworkError.networkFailure))
            }
        }
    }
    
    func login(user: UserAuthenticationRequest,
               completion: @escaping (Result<UserAuthenticationResponse, NetworkError>) -> Void) {
        
        guard let url = resource.buildUrl(for: .loginUser) else {
            completion(.failure(NetworkError.badUrl))
            return
        }
        Task {
            do {
                let data = try encoder.encode(user)
                let responseData = try await load(url, method: .POST, body: data)
                let response = try decoder.decode(UserAuthenticationResponse.self, from: responseData)
                completion(.success(response))
            } catch {
                completion(.failure(NetworkError.networkFailure))
            }
        }
    }
    
    func deleteUser(id: Int, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        
        guard let url = resource.buildUrl(for: .deleteUser, id: id) else {
            completion(.failure(NetworkError.badUrl))
            return
        }
        Task {
            do {
                try await load(url, method: .DELETE)
                completion(.success(true))
            } catch {
                completion(.failure(NetworkError.networkFailure))
            }
        }
    }
    
    func getAllTasks(completion: @escaping (Result<[TaskResponse], NetworkError>) -> Void) {
        guard let url = resource.buildUrl(for: .task) else {
            completion(.failure(NetworkError.badUrl))
            return
        }
        Task {
            do {
                let data = try await load(url, method: .GET)
                let result = try decoder.decode([TaskResponse].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(NetworkError.networkFailure))
            }
        }
    }
    
    func getTasksForUser(id: Int, completion: @escaping (Result<[TaskResponse?], NetworkError>) -> Void) {
        guard let url = resource.buildUrl(for: .allUserTasks, id: id) else {
            completion(.failure(NetworkError.badUrl))
            return
        }
        Task {
            do {
                let data = try await load(url, method: .GET)
                let result = try decoder.decode(TasksResponse.self, from: data)
                completion(.success(result.tasks))
            } catch {
                completion(.failure(NetworkError.networkFailure))
            }
        }
    }
    
    func post(task: RegisterTaskRequest, completion: @escaping (Result<RegisterTaskResponse, NetworkError>) -> Void) {
        guard let url = resource.buildUrl(for: .task) else {
            completion(.failure(NetworkError.badUrl))
            return
        }
        Task {
            do {
                let data = try encoder.encode(task)
                let responseData = try await load(url, method: .POST, body: data)
                let result = try decoder.decode(RegisterTaskResponse.self, from: responseData)
                completion(.success(result))
            } catch {
                completion(.failure(NetworkError.networkFailure))
            }
        }
    }
    
    func update(with task: UpdateTaskRequest, completion: @escaping (Result<RegisterTaskResponse, NetworkError>) -> Void) {
        guard let url = resource.buildUrl(for: .task) else {
            completion(.failure(NetworkError.badUrl))
            return
        }
        Task {
            do {
                let data = try encoder.encode(task)
                let responseData = try await load(url, method: .PUT, body: data)
                let result = try decoder.decode(RegisterTaskResponse.self, from: responseData)
                completion(.success(result))
            } catch {
                completion(.failure(NetworkError.networkFailure))
            }
        }
    }
    
    func deleteTask(id: Int) {
        guard let url = resource.buildUrl(for: .task, id: id) else {
            return
        }
        Task {
            do {
                try await load(url, method: .DELETE)
            } catch {
                print(error)
            }
        }
    }
}
    

//
//  TasksTableViewController.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-01.
//

import UIKit

class TasksTableViewController: UIViewController {
    
    let service = TaskAPIService()
    var tasks: [TaskResponse?] = []
    
    @UsesAutoLayout private var tableView = UITableView()
    
    private let cellReuseId = "TaskCellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchTasks()
//        fetchUserTasks()
    }
}

extension TasksTableViewController {
    private func setup() {
        title = "Tasks"
        view.backgroundColor = .systemBackground
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        tableView.dataSource = self
        tableView.delegate = self
        addTableViewConstraints()
    }
    
    private func addTableViewConstraints() {
        view.addSubview(tableView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            safeArea.topAnchor.constraint(equalTo: tableView.topAnchor),
            tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.topAnchor),
        ])
    }
}

extension TasksTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let task = tasks[indexPath.row] else { return UITableViewCell() }
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        cell = configureCell(with: task)
        return cell
    }
    
    private func configureCell(with task: TaskResponse) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseId)
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.description
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(tasks.count)
        return tasks.count
    }
}

extension TasksTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let task = tasks[indexPath.row]
    }
}

// MARK: - Networking
extension TasksTableViewController {
    func fetchUserTasks() {
        guard let userId = getUserId() else { return }
        service.getTasksForUser(id: userId) { tasks in
            self.tasks = tasks
        }
    }
    
    private func getUserId() -> Int? {
        if let data = UserDefaults.standard.object(forKey: "userInfo") as? Data {
            let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data)
            return userInfo?.id
        }
        return nil
    }
    
    #if DEBUG
    func fetchTasks() {
        service.getTasksForUser(id: 83) { tasks in
            self.tasks = tasks
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    #endif
}

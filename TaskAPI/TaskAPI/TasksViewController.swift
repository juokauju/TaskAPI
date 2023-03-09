//
//  TasksViewController.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-01.
//

import UIKit

class TasksViewController: UIViewController {
    var tasks: [TaskResponse?]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @UsesAutoLayout private var tableView = UITableView()
    
    private let cellReuseId = "TaskCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchUserTasks()
    }
}

extension TasksViewController {
    private func setup() {
        title = "Tasks"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemFill
        addTableViewConstraints()
    }
    
    private func addTableViewConstraints() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.backgroundColor = .systemFill
        
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        setupAddNavigationBarItem()
    }
    
    private func setupAddNavigationBarItem() {
        let iconImage = UIImage(systemName: "plus.square")
        let addBarItem = UIBarButtonItem(image: iconImage, style: .plain, target: self, action: #selector(addBarButtonTapped))
        navigationItem.rightBarButtonItem = addBarItem
    }
    
    @objc private func addBarButtonTapped(_ sender: UIBarButtonItem) {
        print("yey")
    }
}

extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let task = tasks?[indexPath.row] else { return UITableViewCell() }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        cell = configureCell(with: task)
        
        return cell
    }
    
    private func configureCell(with task: TaskResponse) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseId)
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.description
        cell.detailTextLabel?.textColor = .secondaryLabel
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
    
}

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let task = tasks?[indexPath.row] else { return }
        
        let detailVC = DetailTaskViewController(task: task)
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - Networking
extension TasksViewController {
    func fetchUserTasks() {
        guard let userId = UserManager.userId
        else {
            print("no userid")
            return
        }
        TaskAPIService().getTasksForUser(id: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    self?.tasks = tasks
                    print(tasks)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func getUserId() -> Int? {
        if let data = UserDefaults.standard.object(forKey: "userInfo") as? Data {
            let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data)
            return userInfo?.id
        }
        return nil
    }
}

// MARK: - DetailTaskViewControllerDelegate
extension TasksViewController: DetailTaskViewControllerDelegate {
    func update(with task: TaskResponse) -> NetworkError? {
        //        let updateTaskRequest = UpdateTaskRequest(title: task.title,
        //                                                  description: task.description,
        //                                                  estimateMinutes: task.estimateMinutes,
        //                                                  assigneeId: task.assigneeInfo.id,
        //                                                  loggedTime: task.loggedTime,
        //                                                  isDone: task.isDone)
        //
        //        service.update(with: updateTaskRequest) { result in
        //            switch result {
        //            case .success(let taskId):
        //                print(taskId)
        //                return nil
        //            case.failure(let error):
        //                return error
        //            }
        //        }
        return nil
    }
}

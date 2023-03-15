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
    
    private var newTask: TaskResponse?
    
    @UsesAutoLayout private var tableView = UITableView()
    
    private let cellReuseId = "TaskCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchUserTasks()
    }
}

// MARK: - Setup view
extension TasksViewController {
    private func setupView() {
        title = "Tasks"
        view.backgroundColor = .secondarySystemBackground
        
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
        scrollEdgeAppearance.backgroundColor = .lightText
        
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        setupAddNavigationBarItem()
    }
    
    private func setupAddNavigationBarItem() {
        let iconImage = UIImage(systemName: "plus.square")
        let addBarItem = UIBarButtonItem(image: iconImage, style: .plain, target: self, action: #selector(addBarButtonTapped))
        navigationItem.rightBarButtonItem = addBarItem
    }
}

// MARK: - TableView Data Source
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

// MARK: - TableView Delegate
extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let task = tasks?[indexPath.row] else { return }
        
        let detailVC = DetailTaskViewController(task: task)
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let id = tasks?[indexPath.row]?.id else { return }
            deleteTask(withId: id) { [weak self] deleted in
                if deleted {
                    self?.tasks?.remove(at: indexPath.row)
                }
            }
        }
    }
}

// MARK: - Actions
extension TasksViewController {
    @objc private func addBarButtonTapped(_ sender: UIBarButtonItem) {
        showAddNewTaskAlert()
    }
}

// MARK: - Networking
extension TasksViewController {
    private func fetchUserTasks() {
        guard let userId = UserManager.userId else {
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
                    self?.showErrorAlert()
                }
            }
        }
    }
    
    private func postNewTask() {
        guard let newTask = newTask else { return }
        let taskRequest = TaskRequest(title: newTask.title ?? "new task",
                                      description: newTask.description ?? "description",
                                      estimateMinutes: newTask.estimateMinutes,
                                      assigneeId: newTask.assigneeInfo.id)
        
        TaskAPIService().post(task: taskRequest) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let taskResponse):
                    self?.newTask?.id = taskResponse.taskId
                    self?.tasks?.append(newTask)
                case .failure(let error):
                    print(error)
                    self?.showErrorAlert()
                }
            }
        }
    }
    
    private func deleteTask(withId: Int, completion: @escaping (Bool) -> Void) {
        TaskAPIService().deleteTask(withId: withId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    completion(true)
                case .failure(_):
                    self?.showErrorAlert()
                    completion(false)
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

// MARK: - Alerts
extension TasksViewController {
    private func showErrorAlert() {
        let alert = AlertBuilder(viewController: self,
                                 title: "Error!",
                                 message: "Backend error presented",
                                 messageTwo: nil,
                                 messageThree: nil)
        alert.showAlertWithOK(action: nil)
    }
    
    private func showAddNewTaskAlert() {
        let alert = AlertBuilder(viewController: self,
                                 title: "Add a task",
                                 message: "Title",
                                 messageTwo: "Description",
                                 messageThree: "Estimate minutes")
        alert.showThreeTextFieldAlerts { [weak self] array in
            self?.createNewTaskFrom(array: array)
            self?.postNewTask()
            self?.showSuccessAlert()
        }
    }
    
    private func showSuccessAlert() {
        let alert = AlertBuilder(viewController: self,
                                 title: "Success!",
                                 message: "Task completed",
                                 messageTwo: nil,
                                 messageThree: nil)
        alert.showAlertWithOK(action: nil)
    }
    
    private func createNewTaskFrom(array: [String]) {
        let title = array[0]
        let description = array[1]
        let minutes = Int(array[2])
        
        guard let minutes = minutes,
              let userInfo = UserManager.userInfo else { return }
        let task = TaskResponse(id: nil, title: title, description: description, estimateMinutes: minutes, loggedTime: 0, isDone: false, assigneeInfo: userInfo)
        newTask = task
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

//
//  DetailTaskViewController.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-02.
//

import UIKit

class DetailTaskViewController: UIViewController {
    @UsesAutoLayout private var tableView = UITableView()
    private let cellReuseId = "DetailViewCell"
    private let valueReuseId = ValueTableViewCell.reuseId
    private let stepperReuseId = StepperTableViewCell.reuseId
    
    private var task: TaskResponse
    
    init(task: TaskResponse) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
    }
}

extension DetailTaskViewController {
    private func setup() {

    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        tableView.register(ValueTableViewCell.self, forCellReuseIdentifier: valueReuseId)
        tableView.register(StepperTableViewCell.self, forCellReuseIdentifier: stepperReuseId)
        tableView.dataSource = self
//        tableView.delegate = self
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

extension DetailTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        if indexPath.row == 1 {
            configuration.text = task.title
        } else if indexPath.row == 2 {
            configuration.text = task.description
        } else if indexPath.row == 3 {
            configureEstimateCell(with: task, indexPath: indexPath)
        } else if indexPath.row == 4 {
            configueLoggedCell(with: task, indexPath: indexPath)
        } else if indexPath.row == 5 {
            configuration.text = task.assigneeInfo.username
        }
        cell.contentConfiguration = configuration
        return cell
    }
    
    private func configureEstimateCell(with task: TaskResponse, indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: valueReuseId, for: indexPath) as? ValueTableViewCell
        let minutes = String(task.estimateMinutes)
        cell?.configure(with: "Estimated minutes", value: minutes)
    }
    
    private func configueLoggedCell(with task: TaskResponse, indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: stepperReuseId, for: indexPath) as? StepperTableViewCell
        cell?.configure(with: "Logged time", value: task.loggedTime, valueChangedHandler: { [weak self] newValue in
            guard let self = self else { return }
            self.task.loggedTime = newValue
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
}

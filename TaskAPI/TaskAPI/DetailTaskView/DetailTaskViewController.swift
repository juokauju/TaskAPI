//
//  DetailTaskViewController.swift
//  TaskAPI
//
//  Created by Justina Siaulyte on 2023-03-02.
//

import UIKit

protocol DetailTaskViewControllerDelegate: NSObject {
    func update(with task: TaskResponse)
}

class DetailTaskViewController: UIViewController {
    weak var delegate: DetailTaskViewControllerDelegate?
    
    @UsesAutoLayout private var tableView = UITableView()
    @UsesAutoLayout private var updateButton = UIButton()
    
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

    }
}

extension DetailTaskViewController {
    private func setup() {
        title = "Task"
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    private func setupTableView() {
        registerCells()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemFill
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
          tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
          tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
          tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
          tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      ])
    }
    
    private func registerCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        tableView.register(ValueTableViewCell.self, forCellReuseIdentifier: valueReuseId)
        tableView.register(StepperTableViewCell.self, forCellReuseIdentifier: stepperReuseId)
    }
    
    private func setupUpdateButton() {
        var config = UIButton.Configuration.filled()
        config.titleAlignment = .center
        config.titlePadding = 20
        config.buttonSize = .large
        config.baseBackgroundColor = .black
        config.cornerStyle = .large
        updateButton.configuration = config
    
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .primaryActionTriggered)
        view.addSubview(updateButton)
        NSLayoutConstraint.activate([
            updateButton.topAnchor.constraint(equalToSystemSpacingBelow: tableView.bottomAnchor, multiplier: 4),
            updateButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            updateButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20)
        ])
    }
    
    @objc private func updateButtonTapped(_ sender: UIButton) {
        delegate?.update(with: task)
        // update service
        // go back to parent view
    }
}

extension DetailTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = task.title
        } else if indexPath.row == 1 {
            cell.textLabel?.text = task.description
        } else if indexPath.row == 2 {
            cell = configureEstimateCell(with: task, indexPath: indexPath)
        } else if indexPath.row == 3 {
            cell = configueLoggedCell(with: task, indexPath: indexPath)
        } else if indexPath.row == 4 {
            cell.textLabel?.text = task.assigneeInfo.username
        }
        return cell
    }
    
    private func configureEstimateCell(with task: TaskResponse, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: valueReuseId,
                                                       for: indexPath) as? ValueTableViewCell
        else { return UITableViewCell() }
        
        let minutes = String(task.estimateMinutes)
        cell.configure(with: "Estimated minutes", value: minutes)
        return cell
    }
    
    private func configueLoggedCell(with task: TaskResponse, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: stepperReuseId,
                                                       for: indexPath) as? StepperTableViewCell
        else { return UITableViewCell() }
        
        cell.configure(with: "Logged time", value: task.loggedTime, valueChangedHandler: { [weak self] newValue in
            guard let self = self else { return }
            self.task.loggedTime = newValue
            self.tableView.reloadData()
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
}

extension DetailTaskViewController: UITableViewDelegate {
    
}

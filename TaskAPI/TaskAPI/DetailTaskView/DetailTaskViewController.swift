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
    
    private let task: TaskResponse
    
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
}

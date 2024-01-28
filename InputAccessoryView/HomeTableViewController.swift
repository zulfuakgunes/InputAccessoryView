//
//  HomeTableViewController.swift
//  InputAccessoryView
//
//  Created by Zülfü Akgüneş on 28.01.2024.
//

import UIKit

class HomeTableViewController: UIViewController {
    
    lazy var homeTableView: UITableView = {
       let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        return tableView
    }()
    
    lazy var stickyButton: UIButton = {
            let button = UIButton()
            button.setTitle("Beni Tıkla", for: .normal)
            button.backgroundColor = .blue
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

extension HomeTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello world"
        return cell
    }
    
    func setupTableView() {
        NSLayoutConstraint.activate([
            homeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Buton constraints
        NSLayoutConstraint.activate([
            stickyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stickyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stickyButton.widthAnchor.constraint(equalToConstant: 200),
            stickyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
}

#Preview {
    HomeTableViewController()
}

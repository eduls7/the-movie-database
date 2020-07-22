//
//  TableViewController.swift
//  TheMoviewDB
//
//  Created by Eduardo  on 20/07/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import UIKit

class FavoritesTableViewController: UIViewController {
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    //MARK: - Properties
    var titles = ["Onef", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight"]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
//        tableView.estimatedRowHeight = 400
//        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
}



// MARK: - UI Setup
extension FavoritesTableViewController {
    
    private func setupUI() {
        if #available(iOS 13.6, *) {
            overrideUserInterfaceStyle = .light
        }
        //self.view.backgroundColor = .white
        setupUINavigationBarController()
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        ])
    }
    
    func setupUINavigationBarController () {
        self.navigationItem.title = "Favorites"
        self.navigationController?.navigationBar.barTintColor = .systemYellow
    }
}



// MARK: - UICollectionViewDelegate & Data Source
extension FavoritesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! FavoritesTableViewCell
        cell.titleLabel.text = titles[indexPath.row]
        
        return cell
        
    }
    
    
}

//
//  DateFilterViewController.swift
//  TheMovieDB
//
//  Created by Eduardo  on 20/08/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import UIKit
import CoreData

protocol SelectFilterYear {
    func dateFilter(_ year: String, _ type: FilterType)
    
}

class DateFilterViewController: UIViewController {
    
    //MARK: - PROPERTIES
    var years: [String] = []
    var delegate: SelectFilterYear?
    lazy var emptyFooterview: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = footerView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DateFilterTableViewCell.self, forCellReuseIdentifier: "DateFilter")
   
        return tableView
    }()
    
    
    lazy var footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - INITIALIZERS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    
}

//MARK: - Table View Data Source & Delegates
extension DateFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return years.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateFilter", for: indexPath) as! DateFilterTableViewCell
        
        cell.year.text = years[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("deselected call")
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                delegate?.dateFilter(years[indexPath.row], .year)
            }else{
                cell.accessoryType = .none
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    
}

extension DateFilterViewController {
    func setupUI () {
        self.view.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            
            
        ])
    }
}

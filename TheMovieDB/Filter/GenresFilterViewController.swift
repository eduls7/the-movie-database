//
//  GenresFilterViewController.swift
//  TheMovieDB
//
//  Created by Eduardo  on 20/08/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import UIKit

protocol SelectFilterGenre {
    func genreFilter (genre: String)
}

class GenresFilterViewController: UIViewController {
    
    //MARK: - Properties
    var genresID: [Int] = []
    var genresNames: [String] = []
    let network = Network()
    var delegate: SelectFilterGenre?

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.tableFooterView = emptyFooterview
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GenresTableViewCell.self, forCellReuseIdentifier: "GenresFilter")
        
        return tableView
    }()
    
    //MARK: - INITIALIZERS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGenres(genresMoviesID: genresID)
        setupUI()
    }
    
    func getGenres (genresMoviesID: [Int]) {
        print(genresID)
        network.fetchGenresAPI { (genres) in
            for genre in genres {
                for genreID in self.genresID {
                    if genre.id == genreID {
                        self.genresNames.append(genre.name)
                    }
                }
            }
            self.tableView.reloadData()
            print(self.genresNames.count)
            print(self.genresNames)
        }
    }

    
}

//MARK: - Table View Data Source & Delegates
extension GenresFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genresNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenresFilter", for: indexPath) as! GenresTableViewCell
        
        cell.genres.text = genresNames[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                print(genresNames[indexPath.row])
                delegate?.genreFilter(genre: genresNames[indexPath.row])
            }else{
                cell.accessoryType = .none
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension GenresFilterViewController {
    func setupUI () {
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            
            
        ])
    }
}

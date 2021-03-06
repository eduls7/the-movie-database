//
//  FilterViewController.swift
//  TheMovieDB
//
//  Created by Eduardo  on 19/08/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import UIKit
import CoreData

protocol FilterMovies {
    func updateListMoviesWithFilterYear(yearFilter: String)
    func updateListMoviesWithFilterGenre(genreFilter: String)
}

enum FilterType {
    case genre
    case year
}

class FilterViewController: UIViewController, SelectFilterYear, SelectFilterGenre {
    
    //MARK: - PROPERTIES
    var filters: [String] = ["Date", "Genres"]
    var yearFilter: String?
    var genreFilter: String?
    var genresNames: [String] = []
    var delegate: FilterMovies?
    var moviesDataBase: [NSManagedObject] = []
    var datesMovies: [String] = []
    var filterType: FilterType?
    
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
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 45
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FilterViewCell.self, forCellReuseIdentifier: "FilterTableViewCell")
        
        return tableView
    }()
    
    lazy var applyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 247/255, green: 206/255, blue: 91/255, alpha: 1)
        button.setTitle("Apply", for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(applyFilter(button:)), for: .touchUpInside)
        return button
    }()
    
    @objc func applyFilter (button: UIButton) {
        guard let filterType = filterType else { return }
        switch filterType {
        case .year:
            delegate?.updateListMoviesWithFilterYear(yearFilter: yearFilter!)
            navigationController?.popViewController(animated: true)
            break
        case .genre:
            delegate?.updateListMoviesWithFilterGenre(genreFilter: genreFilter!)
            navigationController?.popViewController(animated: true)
            break
        }
        
    }
    
    func dateFilter(_ year: String, _ type: FilterType) {
        self.yearFilter = year
        self.filterType = type
    }
    
    func genreFilter(_ genre: String, _ type: FilterType) {
        self.genreFilter = genre
        self.filterType = type
    }
    
    //MARK: - INITIALIZERS
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getDateMovies()
        getGenres()
        
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getDateMovies () {
        for movie in moviesDataBase {
            let dateMovie = movie.value(forKey: "release_date") as? String
            if let date = dateMovie {
                if !datesMovies.contains(date) {
                    datesMovies.append(String(date.prefix(4)))
                }
            }
        }
    }
    
    func getGenres () {
        for movie in moviesDataBase {
            let genresMoviesDB = movie.value(forKey: "genresID") as? [String]
            if let genresMovies = genresMoviesDB {
                for genres in genresMovies {
                    if !genresNames.contains(genres) {
                        genresNames.append(genres)
                    }
                }
                //print(genresNames.count)
            }
        }
    }

}

//MARK: - Table View Data Source & Delegates
extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as! FilterViewCell
        
        cell.filterTypeLabel.text = filters[indexPath.row]
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let dateFilterViewController = DateFilterViewController()
            dateFilterViewController.delegate = self
            dateFilterViewController.years = datesMovies
            navigationController?.pushViewController(dateFilterViewController, animated: true)
        }else{
            let genresFilterViewController = GenresFilterViewController()
            genresFilterViewController.delegate = self
            genresFilterViewController.genresNames = genresNames
            navigationController?.pushViewController(genresFilterViewController, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension FilterViewController {
    func setupUI () {
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        self.view.addSubview(applyButton)
        
        self.navigationItem.title = "Filter"
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            
            applyButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            applyButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            applyButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            applyButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            applyButton.heightAnchor.constraint(equalToConstant: 40)
            

        ])
    }
}

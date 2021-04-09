//
//  TableViewController.swift
//  TheMoviewDB
//
//  Created by Eduardo  on 20/07/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import UIKit
import CoreData

protocol UnfavoriteMovieRow: class {
    func unfavoriteMovie (_ id: Int)
}

class FavoritesMoviesViewController: UIViewController {
    
    //MARK: - Properties
    let network = Network()
    let dataBase = DataBase()
    weak var delegate: UnfavoriteMovieRow?

    var moviesDataBase: [NSManagedObject] = []
    var moviesTotalDataBase: [NSManagedObject] = []
    var genresNames: [String] = []
    var genresNamesTotal: [String] = []
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoritesViewCell.self, forCellReuseIdentifier: "FavoritesTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 150
        
        return tableView
    }()
    
    lazy var removeFilterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 45/255, green: 48/255, blue: 71/255, alpha: 1)
        button.setTitle("Remove Filter", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(removeFilterMovies(button:)), for: .touchUpInside)
        return button
    }()
    
    lazy var filterBarButton: UIBarButtonItem = {
        let button = UIButton()
        let image = UIImage(named: "FilterIcon")
        
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(filterMovies(button:)), for: .touchUpInside)
        let buttonBar = UIBarButtonItem(customView: button)
        
        return buttonBar
    }()
    
    //MARK: - NSLAYOUT Constraints
    var leftConstraintTableView: NSLayoutConstraint?
    var rightConstraintTableView: NSLayoutConstraint?
    var topConstraintTableView: NSLayoutConstraint?
    var bottomConstraintTaableView: NSLayoutConstraint?
    
    var leftConstraintButton: NSLayoutConstraint?
    var rightConstraintButton: NSLayoutConstraint?
    var topConstraintButton: NSLayoutConstraint?
    var heightConstraintButton: NSLayoutConstraint?
    var removeFilterButtonIsActive = false
    
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        moviesTotalDataBase = dataBase.getMoviesDataBase()
        moviesDataBase = moviesTotalDataBase
        setupUI()
    }
    
    
}





// MARK: - UITableviewViewDelegate & Data Source
extension FavoritesMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesDataBase.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesViewCell
        
        let movie = moviesDataBase[indexPath.row]
        
        
        cell.titleLabel.text = movie.value(forKeyPath: "title") as? String
        cell.releaseDate.text = movie.value(forKeyPath: "release_date") as? String
        
        
        cell.overview.text = movie.value(forKeyPath: "overview") as? String
        let data = movie.value(forKeyPath: "poster") as? Data
        
        if let data = data {
            cell.movieImage.image = UIImage(data: data)
        }
        return cell
        
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let movie = moviesDataBase[indexPath.row]
            let id = movie.value(forKeyPath: "id") as? Int
            guard let movieID = id else { return }
            delegate?.unfavoriteMovie(movieID)
            dataBase.removeMovie(movieID) { (movies) in
                self.moviesTotalDataBase = movies
                self.moviesDataBase.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}



extension FavoritesMoviesViewController: DataSourceMovieDelegate {
    
    func insertMovie(_ movie: MovieViewModel, _ button: UIButton) {
        dataBase.insertMovie(movie) { (movieNew) in
            self.moviesDataBase.append(movieNew)
            self.moviesTotalDataBase.append(movieNew)
            self.tableView.reloadData()
            button.isSelected = true
        }
    }
    
    
    func removeMovie(_ movie: MovieViewModel, _ button: UIButton) {
        
        dataBase.removeMovie(movie.id) { (movies) in
            self.moviesTotalDataBase = movies
            self.moviesDataBase = movies
            self.tableView.reloadData()
            button.isSelected = false
        }
    }
}

extension FavoritesMoviesViewController: FilterMovies {
    //MARK: - Filter Movie Protocol
    @objc func filterMovies (button: UIButton) {
        let filterViewController = FilterViewController()
        filterViewController.delegate = self
        filterViewController.moviesDataBase = moviesDataBase
        self.navigationController?.pushViewController(filterViewController, animated: true)
    }
    
    @objc func removeFilterMovies (button: UIButton) {
        moviesDataBase = moviesTotalDataBase
        removeFilterButtonIsActive = false
        updateUI()
        tableView.reloadData()
    }
    
    
    func updateListMoviesWithFilterYear(yearFilter: String) {
        
        if let movies = dataBase.getMovie(withYear: yearFilter) {
            moviesDataBase = movies
            removeFilterButtonIsActive = true
            updateUI()
            tableView.reloadData()
        }
    }
    
    
    func updateListMoviesWithFilterGenre(genreFilter: String) {
        getGenres(genre: genreFilter)
        
        if !moviesDataBase.isEmpty {
            removeFilterButtonIsActive = true
            updateUI()
            tableView.reloadData()
        }
    }
    
    func getGenres (genre: String) {
        var moviesDataBaseFiltred: [NSManagedObject] = []
        for movieDB in moviesDataBase {
            let genresMoviesDB = movieDB.value(forKey: "genresID") as? [String]
            if let genresMoviesDB = genresMoviesDB {
                if genresMoviesDB.contains(genre) {
                    moviesDataBaseFiltred.append(movieDB)
                }
            }
        }
        print(moviesDataBaseFiltred.count)
        moviesDataBase = moviesDataBaseFiltred
    }
}

// MARK: - UI Setup
extension FavoritesMoviesViewController {
    
    private func setupUI() {
        if #available(iOS 13.6, *) {
            overrideUserInterfaceStyle = .light
        }
        
        setupUINavigationBarController()
        self.view.addSubview(tableView)
        
        
        topConstraintTableView = tableView.topAnchor.constraint(equalTo: self.view.topAnchor)
        topConstraintTableView?.isActive = true
        
        bottomConstraintTaableView = tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        bottomConstraintTaableView?.isActive = true
        
        rightConstraintTableView = tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        rightConstraintTableView?.isActive = true
        
        leftConstraintTableView = tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        leftConstraintTableView?.isActive = true
    }
    
    func updateUI () {
        if removeFilterButtonIsActive == true {
            self.view.addSubview(removeFilterButton)
            
            topConstraintButton = removeFilterButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
            topConstraintButton?.isActive = true
            
            leftConstraintButton = removeFilterButton.leftAnchor.constraint(equalTo: self.view.leftAnchor)
            leftConstraintButton?.isActive = true
            
            rightConstraintButton = removeFilterButton.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            rightConstraintButton?.isActive = true
            
            heightConstraintButton = removeFilterButton.heightAnchor.constraint(equalToConstant: 40)
            heightConstraintButton?.isActive = true
            
            topConstraintTableView?.isActive = false
            topConstraintTableView = tableView.topAnchor.constraint(equalTo: removeFilterButton.bottomAnchor, constant: 0)
            topConstraintTableView?.isActive = true
            
        } else {
            
            topConstraintButton?.isActive = false
            leftConstraintButton?.isActive = false
            rightConstraintButton?.isActive = false
            heightConstraintButton?.isActive = false
            
            topConstraintTableView?.isActive = false
            topConstraintTableView = tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
            topConstraintTableView?.isActive = true
            
        }
    }
    
    func setupUINavigationBarController () {
        self.navigationItem.title = "Favorites"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 247/255, green: 206/255, blue: 91/255, alpha: 1)
        navigationItem.rightBarButtonItem = filterBarButton
    }
}

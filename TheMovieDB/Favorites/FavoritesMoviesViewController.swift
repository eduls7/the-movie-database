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
    var movies: [Movie] = []
    weak var delegate: UnfavoriteMovieRow?
    var managedContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movies")
    var moviesDB: [NSManagedObject] = []
    var result: [NSManagedObject] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            moviesDB = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        setupUI()
        
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoritesViewCell.self, forCellReuseIdentifier: "FavoritesTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
}

// MARK: - UI Setup
extension FavoritesMoviesViewController {
    
    private func setupUI() {
        if #available(iOS 13.6, *) {
            overrideUserInterfaceStyle = .light
        }
        
        setupUINavigationBarController()
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    func setupUINavigationBarController () {
        self.navigationItem.title = "Favorites"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 247/255, green: 206/255, blue: 91/255, alpha: 1)
    }
}

// MARK: - UICollectionViewDelegate & Data Source
extension FavoritesMoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesDB.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesViewCell
        //cell.titleLabel.text = movies[indexPath.row].title
        
        let movie = moviesDB[indexPath.row]
        
        //let test = movie.value(forKeyPath: "genresID") as? [Int]
        
        //print(test!)
        
        cell.titleLabel.text = movie.value(forKeyPath: "title") as? String
        cell.releaseDate.text = movie.value(forKeyPath: "release_date") as? String
        cell.overview.text = movie.value(forKeyPath: "overview") as? String
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movie = moviesDB[indexPath.row]
            let id = movie.value(forKeyPath: "id") as? Int
            delegate?.unfavoriteMovie(id!)
            managedContext.delete(movie)
            moviesDB.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            do{
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save deletion of object. \(error), \(error.userInfo)")
            }
        }
    }
    
    
}

extension FavoritesMoviesViewController: DataSourceMovieDelegate {
    //Insert
    func insermovie(_ movie:  Movie) {
        
        let entityMovie = NSEntityDescription.entity(forEntityName: "Movies", in: managedContext)!
        let movieNew = NSManagedObject(entity: entityMovie, insertInto: managedContext)
        
        movieNew.setValue(movie.id, forKey: "id")
        movieNew.setValue(movie.title, forKey: "title")
        movieNew.setValue(movie.isFav, forKey: "isFav")
        movieNew.setValue(movie.poster, forKey: "poster")
        movieNew.setValue(movie.overview, forKey: "overview")
        movieNew.setValue(movie.releaseDate, forKey: "release_date")
        
        let genresID = movie.genre as [NSNumber]
        movieNew.setValue(genresID, forKey: "genresID")
        
        do{
            try managedContext.save()
            moviesDB.append(movieNew)
            
        } catch let error as NSError {
            print("Could not save new. \(error), \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
    //Remove
    func removeMovie(_ movie: Movie) {
        var index = 0
        for movieDB in moviesDB {
            let movieID = movieDB.value(forKeyPath: "id") as? Int
            if movieID == movie.id {
                print("Equal  movies")
                moviesDB.remove(at: index)
                tableView.reloadData()
            }
            index += 1
        }
        do{
            fetchRequest.predicate = NSPredicate(format: "id = %i", movie.id)
            result = try managedContext.fetch(fetchRequest)
            managedContext.delete(result[0])
            
            do{
                try managedContext.save()
                
            } catch let error as NSError {
                print("Could not save movie deleted. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
    }
}

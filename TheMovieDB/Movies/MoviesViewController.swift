//
//  HomeMoviesViewController.swift
//  TheMoviewDB
//
//  Created by Eduardo  on 20/07/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import UIKit
import CoreData

protocol DataSourceMovieDelegate: class {
    func insertMovie (_ movie: Movie)
    func removeMovie (_ movie: Movie)
}
class MoviesViewController: UIViewController, UnfavoriteMovieRow, UISearchResultsUpdating {
    
    
    
    //MARK: - Properties
    let network = Network()
    var page = 1
    var selectedIndexPath: IndexPath?
    var popularMoviesTotal: [Movie] = []
    var popularMovies: [Movie] = []
    weak var delegate: DataSourceMovieDelegate?
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movies")
    var moviesDataBase: [NSManagedObject] = []
    var isMoreDataLoading = false
    var managedContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.register(MoviesViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var searchController: UISearchController = {
        let search = UISearchController()
        search.searchResultsUpdater = self
        return search
    }()
    
    //MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMoviesDataBase()
        fetchMovies()
        DispatchQueue.visib
        //setupUI()
                
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        popularMovies = popularMoviesTotal
        if let searchText = searchController.searchBar.text, searchText != "" {
            
            popularMovies = searchText.isEmpty ? popularMoviesTotal: popularMoviesTotal.filter { return $0.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil }
            
        }
        collectionView.reloadData()
    }

    
    
}

// MARK: - UI Setup
extension MoviesViewController {
    private func setupUI() {
        
        if #available(iOS 13.6, *) {
            overrideUserInterfaceStyle = .light
        }
        setupUINavigationBarController()
        self.view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellWidthConstant: CGFloat = UIScreen.main.bounds.width * 0.461
        let cellHeightConstant: CGFloat = UIScreen.main.bounds.height * 0.38
        //        print(cellWidthConstant)
        //        print(cellHeightConstant)
        
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: 10,
                                           bottom: 0,
                                           right: 10)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: cellWidthConstant, height: cellHeightConstant)
        
        return layout
    }
    
    func setupUINavigationBarController () {
        
        if let navigationController = self.navigationController {
            
            let navigationBarAppearence = UINavigationBarAppearance()
            navigationBarAppearence.backgroundColor = UIColor(red: 247/255, green: 206/255, blue: 91/255, alpha: 1)
            
            self.navigationItem.title = "Movies"
            navigationController.navigationBar.prefersLargeTitles = true
            navigationItem.searchController = searchController
            navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearence
            navigationController.navigationBar.standardAppearance = navigationBarAppearence
            searchController.obscuresBackgroundDuringPresentation = false
        }
    }
}



// MARK: - UICollectionViewDelegate & Data Source
extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! MoviesViewCell
        
        cell.titleLabel.text = popularMovies[indexPath.row].title
        
        if popularMovies[indexPath.row].isFav {
            cell.favoriteIconImage.image = UIImage(named: "favorite_full_icon")
        }else{
            cell.favoriteIconImage.image = UIImage(named: "favorite_gray_icon")
        }
        
        if let poster = popularMovies[indexPath.row].poster  {
            getImages(imageView: cell.movieImage, imageURL: poster)
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailMovieViewController = DetailMovieViewController()
        detailMovieViewController.titleMovieLabel.text = popularMovies[indexPath.row].title
        detailMovieViewController.releaseDateMovieLabel.text = String(popularMovies[indexPath.row].releaseDate.prefix(4))
        detailMovieViewController.overviewMovieLabel.text = popularMovies[indexPath.row].overview
        
        if let poster = popularMovies[indexPath.row].poster  {
            getImages(imageView: detailMovieViewController.movieImage, imageURL: poster)
        }
        
        getGenres(genresMoviesID: popularMovies[indexPath.row].genre, genreMovieLabel: detailMovieViewController.genreMovieLabel)
        
        
        collectionView.deselectItem(at: indexPath, animated: true)
        detailMovieViewController.delegate = self
        
        selectedIndexPath = indexPath
        
        
        
        if popularMovies[indexPath.row].isFav {
            detailMovieViewController.favoriteButtom.isSelected = true
        } else {
            detailMovieViewController.favoriteButtom.isSelected = false
        }
        
        self.navigationController?.pushViewController(detailMovieViewController, animated: true)
    }
    
}

//MARK: - Favorite Delegate
extension MoviesViewController: FavoriteMovieDelegate {
    
    func updateFavoriteMovie() {
        if let indexPath = selectedIndexPath {
            
            if popularMovies[indexPath.row].isFav == true {
                
                popularMovies[indexPath.row].isFav = false
                popularMoviesTotal[indexPath.row].isFav = false
                delegate?.removeMovie(popularMovies[indexPath.row])
                
            } else {
                popularMovies[indexPath.row].isFav = true
                popularMoviesTotal[indexPath.row].isFav = true
                delegate?.insertMovie(popularMovies[indexPath.row])
            }
            DispatchQueue.main.async {
                self.collectionView.reloadItems(at: [indexPath])
            }
            
        }
    }
}

//MARK: - DATABASE Functions
extension MoviesViewController {
    
    func fetchMoviesDataBase(){
        do{
            moviesDataBase = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func setupMoviesFavs () {
        
        for movieDB in moviesDataBase {
            let movieID = movieDB.value(forKeyPath: "id") as? Int
            var index = 0
            for movie in popularMoviesTotal {
                if movieID == movie.id {
                    popularMoviesTotal[index].isFav = true
                }
                index += 1
            }
            
        }
    }
    
    func unfavoriteMovie(_ id: Int) {
        var index = 0
        for movie in popularMoviesTotal {
            if movie.id == id {
                popularMoviesTotal[index].isFav = false
                popularMovies[index].isFav = false
                collectionView.reloadData()
            }
            index += 1
        }
    }
}
//MARK: - NETWORK
extension MoviesViewController {
    
    func fetchMovies () {
        network.fetchMoviesAPI(page) { (films) in
            
            for film in films {
                
                let movie = Movie(id: film.id, title: film.title, overview: film.overview, releaseDate: film.date, poster: film.poster, genre: film.genre, isFav: false)
                self.popularMoviesTotal.append(movie)
            }
            self.setupMoviesFavs()
            self.popularMovies = self.popularMoviesTotal
            self.setupUI()
        }
        
    }
    
     func loadMoreMovies () {
         network.fetchMoviesAPI(page) { (films) in
             self.isMoreDataLoading = false
             
             for film in films {
                 let movie = Movie(id: film.id, title: film.title, overview: film.overview, releaseDate: film.date, poster: film.poster, genre: film.genre, isFav: false)
                 self.popularMovies.append(movie)
             }
            self.setupMoviesFavs()
            self.popularMovies = self.popularMoviesTotal
            self.collectionView.reloadData()
         }
     }
    
    //isMoreDataLoading start with false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = collectionView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - collectionView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && collectionView.isDragging) {
                isMoreDataLoading = true
                if page <= 499 {
                    page += 1
                    loadMoreMovies()
                }
            }
        }
    }
    
    func getImages (imageView: UIImageView, imageURL: String) {
        network.fetchImagesAPI(imageURLString: imageURL) { (image) in
            imageView.image = image
        }
    }
    
    func getGenres (genresMoviesID: [Int], genreMovieLabel: UILabel) {
        network.fetchGenresAPI { (genres) in
            var namesGenres: [String] = []
            for id in genres {
                for genreID in genresMoviesID {
                    if id.id == genreID {
                        namesGenres.append(id.name)
                        genreMovieLabel.text = namesGenres.joined(separator: ", ")
                    }
                }
            }
        }
    }
}






















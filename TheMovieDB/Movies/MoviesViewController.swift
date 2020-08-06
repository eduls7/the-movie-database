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
    func insermovie (_ movie: Movie)
    func removeMovie (_ movie: Movie)
}
class MoviesViewController: UIViewController, UnfavoriteMovieRow {
    
    //MARK: - Properties
    let network = Network()
    var page = 1
    var popularMoviesJSON: [Films] = []
    var genresList: [Genres] = []
    var popularMovies: [Movie] = []
    var selectedIndexPath: IndexPath?
    weak var delegate: DataSourceMovieDelegate?
    var managedContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movies")
    var moviesDB: [NSManagedObject] = []
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.register(MoviesViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMoviesDB()
        fetchMovies()
        
    }
    
    var isMoreDataLoading = false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = collectionView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - collectionView.bounds.size.height
            
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && collectionView.isDragging) {
                isMoreDataLoading = true
                print("scrolling")
                page += 1
                loadMoreMovies()
                
                // ... Code to load more results ...
            }
            
        }
    }
    
    func fetchMoviesDB(){
        do{
            moviesDB = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func setupMoviesFavs () {
        for movieDB in moviesDB {
            let movieID = movieDB.value(forKeyPath: "id") as? Int
            var index = 0
            for popularMovie in popularMovies {
                if movieID == popularMovie.id {
                    popularMovies[index].isFav = true
                }
                index += 1
            }
            
        }
    }
    
    func unfavoriteMovie(_ id: Int) {
        var index = 0
        for movie in popularMovies {
            if movie.id == id {
                popularMovies[index].isFav = false
                
            }
            index += 1
        }
    }
}

// MARK: - UI Setup
extension MoviesViewController {
    private func setupUI() {
        
        if #available(iOS 13.6, *) {
            overrideUserInterfaceStyle = .light
        }
        
        setupUINavigationBarController()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
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
        self.navigationItem.title = "Movies"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 247/255, green: 206/255, blue: 91/255, alpha: 1)
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
        
        getImages(imageView: cell.movieImage, imageURL: popularMovies[indexPath.row].poster)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailMovieViewController = DetailMovieViewController()
        detailMovieViewController.titleMovieLabel.text = popularMovies[indexPath.row].title
        detailMovieViewController.releaseDateMovieLabel.text = String(popularMovies[indexPath.row].releaseDate.prefix(4))
        detailMovieViewController.overviewMovieLabel.text = popularMovies[indexPath.row].overview
        
        getImages(imageView: detailMovieViewController.movieImage, imageURL: popularMovies[indexPath.row].poster)
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
                delegate?.removeMovie(popularMovies[indexPath.row])
                
            } else {
                popularMovies[indexPath.row].isFav = true
                delegate?.insermovie(popularMovies[indexPath.row])
            }
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

//MARK: - NETWORK
extension MoviesViewController {
    
    func fetchMovies () {
        network.fetchMoviesAPI(page) { (films) in
            self.popularMoviesJSON = films
           
            for film in self.popularMoviesJSON {
                let movie = Movie(id: film.id, title: film.title, overview: film.overview, releaseDate: film.date, poster: film.poster, genre: film.genre, isFav: false)
                self.popularMovies.append(movie)
            }
            
            self.setupMoviesFavs()
            self.setupUI()
        }
    
    }
    
    func loadMoreMovies () {
        network.fetchMoviesAPI(page) { (films) in
            self.isMoreDataLoading = false
            self.popularMoviesJSON = films
            
            for film in self.popularMoviesJSON {
                let movie = Movie(id: film.id, title: film.title, overview: film.overview, releaseDate: film.date, poster: film.poster, genre: film.genre, isFav: false)
                self.popularMovies.append(movie)
            }
            self.setupMoviesFavs()
            self.collectionView.reloadData()
        }
    }
    
    func getGenres (genresMoviesID: [Int], genreMovieLabel: UILabel) {
        network.fetchGenresAPI { (genres) in
            self.genresList = genres
            var namesGenres: [String] = []
            for id in self.genresList {
                for genreID in genresMoviesID {
                    if id.id == genreID {
                        namesGenres.append(id.name)
                        genreMovieLabel.text = namesGenres.joined(separator: ", ")
                    }
                }
            }
        }
    }
    
    func getImages (imageView: UIImageView, imageURL: String) {
        network.fetchImagesAPI(imageURLString: imageURL) { (image) in
            imageView.image = image
        }
    }
}






















//
//  HomeMoviesViewController.swift
//  TheMoviewDB
//
//  Created by Eduardo  on 20/07/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import UIKit
import Foundation



class MoviesCollectionViewController: UIViewController, favoriteMovieDelegate {
    
    func updateFavoriteImage(movieID: Int) {
        if let indexPath = selectedIndexPath {
            if popularMovies[indexPath.row].isFav == true {
                popularMovies[indexPath.row].isFav = false
            } else {
                popularMovies[indexPath.row].isFav = true
            }
            collectionView.reloadData()
        }
    }
    
    
    //MARK: - Properties    
    var moviesJSON: [Films] = []
    var genresList: [Genres] = []
    var popularMovies: [Movie] = []
    var selectedIndexPath: IndexPath?

    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    //MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMovies()
        setupUI()
    }
}

// MARK: - UI Setup
extension MoviesCollectionViewController {
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
extension MoviesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! MoviesCollectionViewCell
        
        cell.titleLabel.text = popularMovies[indexPath.row].title
        
        if popularMovies[indexPath.row].isFav {
            cell.favoriteIconImage.image = UIImage(named: "favorite_full_icon")
        }else{
            cell.favoriteIconImage.image = UIImage(named: "favorite_gray_icon")
        }
        getImageMovies(imageURLString: popularMovies[indexPath.row].poster, imageView: cell.movieImage)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailMovieViewController = DetailMovieViewController()
        
        detailMovieViewController.titleMovieLabel.text = popularMovies[indexPath.row].title
        
        detailMovieViewController.releaseDateMovieLabel.text = String(popularMovies[indexPath.row].releaseDate.prefix(4))
        detailMovieViewController.overviewMovieLabel.text = popularMovies[indexPath.row].overview
        
        getImageMovies(imageURLString: popularMovies[indexPath.row].poster, imageView: detailMovieViewController.movieImage)
        
        getGenresMovies(genresMoviesID: popularMovies[indexPath.row].genre, genreMovieLabel: detailMovieViewController.genreMovieLabel)
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        detailMovieViewController.delegate = self
        detailMovieViewController.movieID = popularMovies[indexPath.row].id
        selectedIndexPath = indexPath
        
        if popularMovies[indexPath.row].isFav {
            detailMovieViewController.favoriteButtom.isSelected = true
        } else {
            detailMovieViewController.favoriteButtom.isSelected = false
        }
        
        self.navigationController?.pushViewController(detailMovieViewController, animated: true)
        
        
    }
    
}


extension MoviesCollectionViewController {
    
    //MARK: - NETWORK
    func fetchMovies () {
        
        let apiKEY = "001b2963f87a5986bb263777245cc788"
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKEY)") else {
            print("URL com problema")
            return
        }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                let decoder = JSONDecoder()
                do{
                    let filmsResponse = try decoder.decode(MovieResponse.self, from: data!)
                    self.moviesJSON = filmsResponse.films
                    self.fetchMovies(movieJSON: self.moviesJSON)
                    self.collectionView.reloadData()
                }
                catch {
                    print("Error with JSON parsing")
                }
            }
        }
        
        dataTask.resume()
    }
    
    func getImageMovies (imageURLString: String, imageView: UIImageView)  {
        
        guard let imageURL = URL(string: "https://image.tmdb.org/t/p/original/\(imageURLString)") else {
            print("Error in convert imageURLString to URL")
            return
        }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else {
                print("Error in convert imageURL to DATA")
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)
                imageView.image = image
            }
        }
    }
    
    func getGenresMovies (genresMoviesID: [Int], genreMovieLabel: UILabel) {
        let apiKEY = "001b2963f87a5986bb263777245cc788"
        guard let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKEY)") else {
            print("URL Genre com problema")
            return
        }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                let decoder = JSONDecoder()
                do{
                    let genreResponse = try decoder.decode(GenreResponse.self, from: data!)
                    self.genresList = genreResponse.genres
                    
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
                catch {
                    print("Error with JSON in Genres parsing")
                    print(error)
                }
            }
        }
        
        dataTask.resume()
    }
    
    func fetchMovies (movieJSON: [Films]) {
        for movies in movieJSON {
            let moviesAux = Movie(id: movies.id, title: movies.title, overview: movies.overview, releaseDate: movies.date, poster: movies.poster, genre: movies.genre, isFav: false)
            
            self.popularMovies.append(moviesAux)
            
        }
    }
    
}



































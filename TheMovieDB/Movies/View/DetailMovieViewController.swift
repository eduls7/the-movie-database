//
//  DetailMovieViewController.swift
//  TheMovieDB
//
//  Created by Eduardo  on 24/07/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import UIKit

protocol FavoriteMovieDelegate: class {
    func updateFavoriteMovie (_ button: UIButton)
}

class DetailMovieViewController: UIViewController {
    //MARK: - Properties
    weak var delegate: FavoriteMovieDelegate?
    let shareView = DetailMovieView()

    //MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
    }
    
    override func loadView() {
        view = shareView
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc func markFavoriteButtom (buttom: UIButton){
        delegate?.updateFavoriteMovie(buttom)
    }
    
    // MARK: - SetupUI
    func setupViewProperties(with movie: MovieViewModel) {
        shareView.titleMovieLabel.text = movie.title
        shareView.releaseDateMovieLabel.text = String(movie.releaseDate.prefix(4))
        shareView.overviewMovieLabel.text = movie.overview
        if let poster = movie.poster  {
            getImages(imageURL: poster)
        }
        getGenres(genresMoviesID: movie.genre)
        
        if movie.isFav {
            shareView.favoriteButtom.isSelected = true
        } else {
            shareView.favoriteButtom.isSelected = false
        }
    }
    
    func getImages (imageURL: String) {
        Network.shared.fetchImagesAPI(imageURLString: imageURL) { (image) in
            self.shareView.movieImage.image = image
        }
    }
    
    func getGenres (genresMoviesID: [Int]) {
        var namesGenres: [String] = []
        Network.shared.fetchGenresAPI { (genres) in
            for id in genres {
                for genreID in genresMoviesID where id.id == genreID {
                    namesGenres.append(id.name)
                    self.shareView.genreMovieLabel.text = namesGenres.joined(separator: ", ")
                }
            }
        }
    }
    
    private func setupUI() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "Movie"
    }
    
}










































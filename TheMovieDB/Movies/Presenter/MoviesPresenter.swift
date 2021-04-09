//
//  MoviesPresenter.swift
//  TheMovieDB
//
//  Created by Eduardo  on 06/04/21.
//  Copyright © 2021 Eduardo . All rights reserved.
//

import Foundation

protocol MoviesPresenterDelegate: class {
    func reloadData()
}

class MoviesPresenter {
    var page = 1
    var popularMovies: [MovieViewModel] = []
    var popularMoviesTotal: [MovieViewModel] = []
    weak var delegate: MoviesPresenterDelegate?
    var isMoreDataLoading = false
    
    init() {
        fetchMovies()
    }
    
    func fetchMovies () {
        Network.shared.fetchMoviesAPI(page) { (films) in
            
            for film in films {
                self.popularMovies.append(MovieViewModel(id: film.id, title: film.title, overview: film.overview, releaseDate: film.date, poster: film.poster, genre: film.genre, isFav: false))
            }
            self.setupMoviesFavs()
            self.delegate?.reloadData()
        }
    }
    
    func loadMoreMovies () {
        Network.shared.fetchMoviesAPI(page) { (films) in
            self.isMoreDataLoading = false
            
            for film in films {
                let movie = MovieViewModel(id: film.id, title: film.title, overview: film.overview, releaseDate: film.date, poster: film.poster, genre: film.genre, isFav: false)
                self.popularMoviesTotal.append(movie)
            }
            self.popularMovies = self.popularMoviesTotal
            self.setupMoviesFavs()
            self.delegate?.reloadData()
        }
    }
    
    func setupMoviesFavs () {
        DataBase.shared.setupMoviesFavs(movies: &popularMovies)
    }
    
}

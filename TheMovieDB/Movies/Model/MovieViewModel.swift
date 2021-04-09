//
//  Movie.swift
//  TheMovieDB
//
//  Created by Eduardo  on 27/07/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import Foundation

struct MovieViewModel {
    var id: Int
    var title: String
    var overview: String
    var releaseDate: String
    var poster: String?
    var genre: [Int]
    var isFav: Bool
}

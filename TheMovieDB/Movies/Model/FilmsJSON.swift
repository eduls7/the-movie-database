//
//  Movie.swift
//  TheMoviewDB
//
//  Created by Eduardo  on 21/07/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import Foundation


struct MovieResponse: Codable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let films: [Film]
    
    enum CodingKeys: String, CodingKey {
        case page
        case total_results
        case total_pages
        case films = "results"
    }
}

struct Film: Codable {
    let id: Int
    let title: String
    var poster: String?
    let genre: [Int]
    let date: String
    let overview: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case poster = "poster_path"
        case genre = "genre_ids"
        case date = "release_date"
        case overview
    }
}

struct GenreResponse: Codable {
    let genres: [Genres]
}

struct Genres: Codable {
    let id: Int
    let name: String
}


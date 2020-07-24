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
    let films: [Films]
    
    enum CodingKeys: String, CodingKey {
        case page
        case total_results
        case total_pages
        case films = "results"
    }
}

struct Films: Codable {
    let id: Int
    let title: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case poster = "poster_path"
    }
}


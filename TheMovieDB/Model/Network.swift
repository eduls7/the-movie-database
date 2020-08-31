//
//  Network.swift
//  TheMovieDB
//
//  Created by Eduardo  on 03/08/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import Foundation
import UIKit

class Network {

    func fetchMoviesAPI (_ page: Int, completionHandler: @escaping([Films]) -> Void) {
        let pageRequest = String(page)
        
        let apiKEY = "001b2963f87a5986bb263777245cc788"
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKEY)&page=\(pageRequest)") else {
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
                    completionHandler(filmsResponse.films)
                }
                catch {
                    print("Error with JSON parsing: \(error)")
                }
            }
        }
        
        dataTask.resume()
    }
    
    func fetchGenresAPI (completionHandler: @escaping([Genres]) -> Void) {
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
                    completionHandler(genreResponse.genres)
                }
                catch {
                    print("Error with JSON in Genres parsing")
                    print(error)
                }
            }
        }
        
        dataTask.resume()
    }
    
    func fetchImagesAPI (imageURLString: String ,completionHandler: @escaping(UIImage) -> Void)  {
        
        guard let imageURL = URL(string: "https://image.tmdb.org/t/p/w300/\(imageURLString)") else {
            print("Error in convert imageURLString to URL")
            return
        }
        DispatchQueue.global(qos: .default).async {
            guard let imageData = try? Data(contentsOf: imageURL) else {
                print("Error in convert imageURL to DATA")
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)
                if let image = image {
                    completionHandler(image)
                }
            }
        }
    }
}

//
//  DataBase.swift
//  TheMovieDB
//
//  Created by Eduardo  on 31/08/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import CoreData
import UIKit

class DataBase {
    var managedContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movies")
    var moviesDataBase: [NSManagedObject] = []
    var fetchResult: [NSManagedObject] = []
    let network = Network()
    var genresNames: [String] = []
    
    init() {
        fetchMoviesDataBase()
    }
    
    func fetchMoviesDataBase(){
        do{
            moviesDataBase = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func getMoviesDataBase () -> [NSManagedObject] {
        return moviesDataBase
    }
    
    func getMovie (withYear year: String) -> [NSManagedObject]? {
        do {
            fetchRequest.predicate = NSPredicate(format: "release_date == \(year)")
            fetchResult = try managedContext.fetch(fetchRequest)
            
            if !fetchResult.isEmpty {
                return fetchResult
            } else {
                print("There isn't a movie with this year: \(year)")
                return nil
            }
            
        } catch let error as NSError {
            print("Could not fetch filter. \(error), \(error.userInfo)")
            
        }
        
        return nil
    }
    
    func setupMoviesFavs (movies: inout [Movie]) {
        
        for movieDB in moviesDataBase {
            let movieID = movieDB.value(forKeyPath: "id") as? Int
            var index = 0
            for movie in movies {
                if movieID == movie.id {
                    movies[index].isFav = true
                }
                index += 1
            }
        }
    }
    
    func insertMovie(_ movie: Movie, completionHandler:  @escaping(NSManagedObject) -> Void)  {
        let entityMovie = NSEntityDescription.entity(forEntityName: "Movies", in: self.managedContext)!
        let movieNew = NSManagedObject(entity: entityMovie, insertInto: managedContext)
        var data: Data?
        
        
        guard let poster = movie.poster else { return print("Poster movie with nil value") }
        
        
        self.network.fetchImagesAPI(imageURLString: poster) { (image) in
            data = image.pngData()
            movieNew.setValue(data, forKey: "poster")
            let yearMovie = String(movie.releaseDate.prefix(4))
            movieNew.setValue(yearMovie, forKey: "release_date")
            movieNew.setValue(movie.id, forKey: "id")
            movieNew.setValue(movie.title, forKey: "title")
            movieNew.setValue(movie.isFav, forKey: "isFav")
            movieNew.setValue(movie.overview, forKey: "overview")
            
            self.network.fetchGenresAPI { (genresReponse) in
                
                for genre in genresReponse {
                    for id in movie.genre {
                        if id == genre.id {
                            self.genresNames.append(genre.name)
                        }
                    }
                }
                
                let genresNames = self.genresNames as [NSString]
                movieNew.setValue(genresNames, forKey: "genresID")
                
                do{
                    try self.managedContext.save()
                    self.genresNames = []
                    self.moviesDataBase.append(movieNew)
                    completionHandler(movieNew)
                    
                } catch let error as NSError {
                    print("Could not save new. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func removeMovie(_ movieID: Int, completionHandler: @escaping ([NSManagedObject]) -> Void) {
        
        do {
            fetchRequest.predicate = NSPredicate(format: "id != %i", movieID)
            fetchResult = try managedContext.fetch(fetchRequest)
            moviesDataBase = fetchResult
            fetchResult = []
        } catch let error as NSError {
            print("Could not delete from movieDataBase. \(error), \(error.userInfo)")
        }
        do{
            fetchRequest.predicate = NSPredicate(format: "id == %i", movieID)
            fetchResult = try managedContext.fetch(fetchRequest)
            if fetchResult.first != nil {
                managedContext.delete(fetchResult.first!)
            }
            do{
                try managedContext.save()
                completionHandler(moviesDataBase)
            } catch let error as NSError {
                print("Could not save movie deleted. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
}

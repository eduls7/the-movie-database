//
//  TabBarViewController.swift
//  TheMoviewDB
//
//  Created by Eduardo  on 20/07/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    let moviesViewController = MoviesViewController()
    let favoritesMoviesViewController = FavoritesMoviesViewController()
    
    let navigationControllerListMovies = UINavigationController()
    let navigationControllerListFavorites = UINavigationController()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        moviesViewController.delegate = favoritesMoviesViewController
        favoritesMoviesViewController.delegate = moviesViewController
        navigationControllerListMovies.addChild(moviesViewController)
        navigationControllerListFavorites.addChild(favoritesMoviesViewController)
        
        self.viewControllers = [navigationControllerListMovies, navigationControllerListFavorites]
    }
    
    
    
    //MARK: - SetupUI
    func setupUI () {
       
        self.tabBar.barTintColor = UIColor(red: 247/255, green: 206/255, blue: 91/255, alpha: 1)
        
        
        navigationControllerListMovies.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(named: "list_icon"), selectedImage: nil)
        
        navigationControllerListFavorites.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "favorite_empty_icon"), selectedImage: nil)
    }
    
}

//
//  TabBarViewController.swift
//  TheMoviewDB
//
//  Created by Eduardo  on 20/07/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationControllerListMovies = UINavigationController(rootViewController: MoviesCollectionViewController())
        let navigationControllerListFavorites = UINavigationController(rootViewController: FavoritesTableViewController())
        
        self.tabBar.barTintColor = .systemYellow
        
        navigationControllerListMovies.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(named: "list_icon"), selectedImage: nil)
        
        navigationControllerListFavorites.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "favorite_empty_icon"), selectedImage: nil)
        
        
        self.viewControllers = [navigationControllerListMovies, navigationControllerListFavorites]
    }
    


}

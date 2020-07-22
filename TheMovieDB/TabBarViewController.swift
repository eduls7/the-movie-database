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
        
        self.tabBar.barTintColor = .white
        
        let listFavorits = TableViewController()
        listFavorits.tabBarItem =  UITabBarItem(title: "TableView", image: nil, selectedImage: nil)
        
        let collectionMovies = CollectionViewController()
        collectionMovies.tabBarItem = UITabBarItem(title: "CollectionView", image: nil, selectedImage: nil)
        
        self.viewControllers = [listFavorits, collectionMovies]
    }
    


}

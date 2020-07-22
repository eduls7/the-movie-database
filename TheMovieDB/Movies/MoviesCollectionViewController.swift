//
//  HomeMoviesViewController.swift
//  TheMoviewDB
//
//  Created by Eduardo  on 20/07/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import UIKit

class MoviesCollectionViewController: UIViewController {
    
    
    //MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
    }
    
    //MARK: - Properties
    var titles: [String] = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight"]
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

}

// MARK: - UI Setup
extension MoviesCollectionViewController {
    private func setupUI() {
        if #available(iOS 13.6, *) {
            overrideUserInterfaceStyle = .light
        }
        
        setupUINavigationBarController()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellWidthConstant: CGFloat = UIScreen.main.bounds.width * 0.461
        let cellHeightConstant: CGFloat = UIScreen.main.bounds.height * 0.3
//        print(cellWidthConstant)
//        print(cellHeightConstant)

        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: 10,
                                           bottom: 0,
                                           right: 10)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: cellWidthConstant, height: cellHeightConstant)
        
        return layout
    }
    
    func setupUINavigationBarController () {
        self.navigationItem.title = "Movies"
        self.navigationController?.navigationBar.barTintColor = .systemYellow
    }
}

// MARK: - UICollectionViewDelegate & Data Source
extension MoviesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! MoviesCollectionViewCell
        cell.titleLabel.text = titles[indexPath.item]
        return cell
    }
    
}

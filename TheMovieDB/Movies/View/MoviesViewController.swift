//
//  HomeMoviesViewController.swift
//  TheMoviewDB
//
//  Created by Eduardo  on 20/07/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import UIKit
import CoreData

protocol DataSourceMovieDelegate: class {
    func insertMovie (_ movie: MovieViewModel, _ button: UIButton)
    func removeMovie (_ movie: MovieViewModel, _ button: UIButton)
}
class MoviesViewController: UIViewController, UnfavoriteMovieRow {
    // MARK: - Properties
    var page = 1
    var selectedIndexPath: IndexPath?
    var popularMoviesTotal: [MovieViewModel] = []
    weak var delegate: DataSourceMovieDelegate?
    let presenter: MoviesPresenter

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.register(MoviesViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var searchController: UISearchController = {
        let search = UISearchController()
        search.searchResultsUpdater = self
        return search
    }()
    
    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(presenter: MoviesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Search
extension MoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let totalMoviesObject = presenter.popularMovies.count
        presenter.popularMovies = popularMoviesTotal
        
        if let searchText = searchController.searchBar.text, searchText != "" {
            
            presenter.popularMovies = searchText.isEmpty ? popularMoviesTotal: popularMoviesTotal.filter { return $0.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil }
        }
        
        if totalMoviesObject != presenter.popularMovies.count  {
            collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate & Data Source
extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.popularMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! MoviesViewCell
        
        cell.setupViewProperties(with: presenter.popularMovies[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailMovieViewController = DetailMovieViewController()
        detailMovieViewController.setupViewProperties(with: presenter.popularMovies[indexPath.row])
        collectionView.deselectItem(at: indexPath, animated: true)
        detailMovieViewController.delegate = self
        selectedIndexPath = indexPath
        self.navigationController?.pushViewController(detailMovieViewController, animated: true)
    }
    
}

// MARK: - Favorite Delegate
extension MoviesViewController: FavoriteMovieDelegate {
    
    func updateFavoriteMovie(_ button: UIButton) {
    
        if let indexPath = selectedIndexPath {
            
            
            if presenter.popularMovies[indexPath.row].isFav == true {
                
                presenter.popularMovies[indexPath.row].isFav = false
                popularMoviesTotal[indexPath.row].isFav = false
                delegate?.removeMovie(presenter.popularMovies[indexPath.row], button)
                
            } else {
                presenter.popularMovies[indexPath.row].isFav = true
                popularMoviesTotal[indexPath.row].isFav = true
                delegate?.insertMovie(presenter.popularMovies[indexPath.row], button)
            }
            
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
}

// MARK: - DATABASE Functions
extension MoviesViewController {
    func unfavoriteMovie(_ id: Int) {
        if let index = popularMoviesTotal.firstIndex(where: { $0.id == id}) {
            popularMoviesTotal[index].isFav = false
            presenter.popularMovies[index].isFav = false
            collectionView.reloadData()
        } else {
            print("Unable to unfavorite movie with index: \(id)")
        }
    }
}
// MARK: - NETWORK
extension MoviesViewController {
    // isMoreDataLoading start with false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!presenter.isMoreDataLoading) {
            let scrollViewContentHeight = collectionView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - collectionView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && collectionView.isDragging) {
                presenter.isMoreDataLoading = true
                if page <= 499 {
                    page += 1
                    presenter.loadMoreMovies()
                }
            }
        }
    }
}

extension MoviesViewController: MoviesPresenterDelegate {
    func reloadData() {
        self.collectionView.reloadData()
    }
}

// MARK: - UI Setup
extension MoviesViewController {
    private func setupUI() {
        if #available(iOS 13.6, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        setupUINavigationBarController()
    
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellWidthConstant: CGFloat = UIScreen.main.bounds.width * 0.461
        let cellHeightConstant: CGFloat = UIScreen.main.bounds.height * 0.38
        
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
        
        if let navigationController = self.navigationController {
            
            let navigationBarAppearence = UINavigationBarAppearance()
            navigationBarAppearence.backgroundColor = UIColor(red: 247/255, green: 206/255, blue: 91/255, alpha: 1)
            
            self.navigationItem.title = "Movies"
            navigationController.navigationBar.prefersLargeTitles = true
            navigationItem.searchController = searchController
            navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearence
            navigationController.navigationBar.standardAppearance = navigationBarAppearence
            searchController.obscuresBackgroundDuringPresentation = false
        }
    }
}






















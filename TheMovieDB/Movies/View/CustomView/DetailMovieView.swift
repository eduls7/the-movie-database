//
//  DetailMovieView.swift
//  TheMovieDB
//
//  Created by Eduardo  on 09/04/21.
//  Copyright © 2021 Eduardo . All rights reserved.
//

import UIKit

class DetailMovieView: UIView {
    //MARK: - Properties
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var lineSeparatorView1: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    lazy var lineSeparatorView2: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    lazy var lineSeparatorView3: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    lazy var titleMovieLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Helvetica Neue", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var releaseDateMovieLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Helvetica Neue", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        
        return label
    }()
    
    lazy var genreMovieLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Helvetica Neue", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var overviewMovieLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Helvetica Neue", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var favoriteButtom: UIButton = {
        let favoriteEmpyImage = UIImage(named: "favorite_empty_icon")
        let favoriteSelectedImage = UIImage(named: "favorite_full_icon")
        let button = UIButton()
        button.setImage(favoriteEmpyImage, for: .normal)
        button.setImage(favoriteSelectedImage, for: .selected)
        button.addTarget(nil, action: #selector(DetailMovieViewController.markFavoriteButtom(buttom:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailMovieView {
    func setupUI () {
        
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(movieImage)
        contentView.addSubview(lineSeparatorView1)
        contentView.addSubview(lineSeparatorView2)
        contentView.addSubview(lineSeparatorView3)
        contentView.addSubview(releaseDateMovieLabel)
        contentView.addSubview(genreMovieLabel)
        contentView.addSubview(overviewMovieLabel)
        contentView.addSubview(favoriteButtom)
        contentView.addSubview(titleMovieLabel)
        
        NSLayoutConstraint.activate([
            
            scrollView.widthAnchor.constraint(equalTo: self.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            movieImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            movieImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            
            lineSeparatorView1.heightAnchor.constraint(equalToConstant: 0.5),
            lineSeparatorView1.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 70),
            lineSeparatorView1.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            lineSeparatorView1.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 10),
            
            titleMovieLabel.bottomAnchor.constraint(equalTo: lineSeparatorView1.topAnchor, constant: -10),
            titleMovieLabel.leadingAnchor.constraint(equalTo: lineSeparatorView1.leadingAnchor, constant: 0),
            titleMovieLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35),
            
            favoriteButtom.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            favoriteButtom.bottomAnchor.constraint(equalTo: lineSeparatorView1.bottomAnchor, constant: -10),

            lineSeparatorView2.heightAnchor.constraint(equalToConstant: 0.5),
            lineSeparatorView2.topAnchor.constraint(equalTo: lineSeparatorView1.bottomAnchor, constant: 60),
            lineSeparatorView2.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            lineSeparatorView2.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 10),
            
            releaseDateMovieLabel.bottomAnchor.constraint(equalTo: lineSeparatorView2.topAnchor, constant: -10),
            releaseDateMovieLabel.leadingAnchor.constraint(equalTo: lineSeparatorView2.leadingAnchor, constant: 0),

            lineSeparatorView3.heightAnchor.constraint(equalToConstant: 0.5),
            lineSeparatorView3.topAnchor.constraint(equalTo: lineSeparatorView2.bottomAnchor, constant: 60),
            lineSeparatorView3.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            lineSeparatorView3.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 10),
            
            genreMovieLabel.bottomAnchor.constraint(equalTo: lineSeparatorView3.topAnchor, constant: -10),
            genreMovieLabel.leadingAnchor.constraint(equalTo: lineSeparatorView3.leadingAnchor, constant: 0),
            genreMovieLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            overviewMovieLabel.topAnchor.constraint(equalTo: lineSeparatorView3.topAnchor, constant: 10),
            overviewMovieLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 10),
            overviewMovieLabel.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -10),
            overviewMovieLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

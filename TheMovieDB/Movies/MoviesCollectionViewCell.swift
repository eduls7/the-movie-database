//
//  CollectionViewCell.swift
//  TheMoviewDB
//
//  Created by Eduardo  on 20/07/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import UIKit

class MoviesViewCell: UICollectionViewCell {
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    // MARK: - Properties
    lazy var cellView: UIView = {
        let view = UIView()
        //view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont(name: "HelveticaNeue", size: 18)
        
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor(red: 247/255, green: 206/255, blue: 91/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.numberOfLines = 2
        return label
    }()
    
    lazy var viewTitleMovie: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 45/255, green: 48/255, blue: 71/255, alpha: 1)
        return view
    }()
    
    lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var favoriteIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
}

// MARK: - UI Setup
extension MoviesViewCell {
    
    private func setupUI() {
        
        self.contentView.addSubview(cellView)
        cellView.addSubview(movieImage)
        cellView.addSubview(viewTitleMovie)
        viewTitleMovie.addSubview(titleLabel)
        viewTitleMovie.addSubview(favoriteIconImage)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            viewTitleMovie.bottomAnchor.constraint(equalTo: cellView.bottomAnchor),
            viewTitleMovie.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            viewTitleMovie.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            viewTitleMovie.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.bottomAnchor.constraint(equalTo: viewTitleMovie.bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: viewTitleMovie.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: viewTitleMovie.leadingAnchor, constant: 10),
            

            favoriteIconImage.trailingAnchor.constraint(equalTo: viewTitleMovie.trailingAnchor, constant: -10),
            favoriteIconImage.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 15),
            favoriteIconImage.topAnchor.constraint(equalTo: viewTitleMovie.topAnchor, constant: 15),
            favoriteIconImage.heightAnchor.constraint(equalToConstant: 20),
            favoriteIconImage.widthAnchor.constraint(equalToConstant: 20),

            movieImage.topAnchor.constraint(equalTo: cellView.topAnchor),
            movieImage.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            movieImage.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            movieImage.bottomAnchor.constraint(equalTo: viewTitleMovie.topAnchor),
        ])
        
    }
}

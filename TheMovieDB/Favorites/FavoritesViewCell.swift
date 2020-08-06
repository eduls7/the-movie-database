//
//  TableViewCell.swift
//  TheMoviewDB
//
//  Created by Eduardo  on 20/07/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import UIKit

class FavoritesViewCell: UITableViewCell {
    
    //MARK: Initialazers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //
    //    }
    
    //MARK: Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 18)
        //label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textColor = .black
        //label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var releaseDate: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var overview: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "Arial", size: 13)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
}

//MARK: - UI Setup
extension FavoritesViewCell {
    private func setupUI() {
        self.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(releaseDate)
        self.contentView.addSubview(overview)
        self.contentView.addSubview(movieImage)
        
        NSLayoutConstraint.activate([
            
            movieImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            movieImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            movieImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            movieImage.heightAnchor.constraint(equalToConstant: 130),
            movieImage.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: overview.topAnchor, constant: -10),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: releaseDate.leadingAnchor),

            releaseDate.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            releaseDate.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            
            overview.topAnchor.constraint(equalTo: releaseDate.bottomAnchor, constant: 10),
            overview.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 10),
            overview.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            overview.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            
        ])
        
        
    }
}

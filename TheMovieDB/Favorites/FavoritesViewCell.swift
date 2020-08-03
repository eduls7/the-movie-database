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
        label.font = UIFont(name: "HelveticaNeue", size: 15)
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
           label.font = UIFont(name: "HelveticaNeue", size: 15)
           label.textColor = .black
           label.numberOfLines = 0
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    
}

//MARK: - UI Setup
extension FavoritesViewCell {
    private func setupUI() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(releaseDate)
        self.contentView.addSubview(overview)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            
            releaseDate.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            releaseDate.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            
            
            overview.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            overview.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            overview.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            overview.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            
        ])
        
        
    }
}

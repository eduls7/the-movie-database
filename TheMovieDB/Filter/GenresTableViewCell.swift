//
//  GenresTableViewCell.swift
//  TheMovieDB
//
//  Created by Eduardo  on 20/08/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import UIKit

class GenresTableViewCell: UITableViewCell {
    
    lazy var genres: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension GenresTableViewCell {
    
    func setupUI () {
        self.addSubview(genres)
        
        NSLayoutConstraint.activate([
            //dateFilterLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            //dateFilterLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0)
        ])
    }
}

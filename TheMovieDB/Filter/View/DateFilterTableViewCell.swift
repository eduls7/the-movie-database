//
//  DateFilterTableViewCell.swift
//  TheMovieDB
//
//  Created by Eduardo  on 20/08/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import UIKit

class DateFilterTableViewCell: UITableViewCell {
    
    lazy var year: UILabel = {
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

extension DateFilterTableViewCell {
    
    func setupUI () {
        self.contentView.addSubview(year)
        
        NSLayoutConstraint.activate([
            year.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            year.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            year.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
           
        ])
    }
}

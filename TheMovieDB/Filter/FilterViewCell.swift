//
//  FilterCell.swift
//  TheMovieDB
//
//  Created by Eduardo  on 19/08/20.
//  Copyright © 2020 Eduardo . All rights reserved.
//

import UIKit

class FilterViewCell: UITableViewCell {
    
    lazy var filterTypeLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var optionFilterLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
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

extension FilterViewCell {
    
    func setupUI () {
        self.addSubview(filterTypeLabel)
        //self.addSubview(optionFilterLabel)
        
        NSLayoutConstraint.activate([
            filterTypeLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            filterTypeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            filterTypeLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            //filterTypeLabel.rightAnchor.constraint(equalTo: optionFilterLabel.leadingAnchor, constant: -80),
            
//            optionFilterLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -30),
//            optionFilterLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
//            optionFilterLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
        ])
    }
}
